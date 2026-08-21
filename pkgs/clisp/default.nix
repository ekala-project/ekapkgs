{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf,
  automake,
  bash,
  libtool,
  libsigsegv,
  gettext,
  ncurses,
  pcre,
  zlib,
  readline,
  libffi,
  libffcall,
  xorg,
  xorgproto,
  coreutils,
  threadSupport ? stdenv.hostPlatform.isx86,
  x11Support ? stdenv.hostPlatform.isx86,
  dllSupport ? true,
  withModules ? [
    "asdf"
    "pcre"
    "rawsock"
    "bindings/glibc"
    "zlib"
  ]
  ++ lib.optional x11Support "clx/new-clx",
}:

let
  ffcallAvailable = libffcall != null;
in

stdenv.mkDerivation {
  version = "2.49.95-unstable-2024-12-28";
  pname = "clisp";

  src = fetchFromGitLab {
    owner = "gnu-clisp";
    repo = "clisp";
    rev = "c3ec11bab87cfdbeba01523ed88ac2a16b22304d";
    hash = "sha256-xXGx2FlS0l9huVMHqNbcAViLjxK8szOFPT0J8MpGp9w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    bash
    libsigsegv
    gettext
    ncurses
    pcre
    zlib
    readline
    libffi
    libffcall
  ]
  ++ lib.optionals x11Support [
    xorg.libX11
    xorg.libXau
    xorg.libXt
    xorg.libXpm
    xorgproto
    xorg.libXext
  ];

  postPatch = ''
    sed -e 's@9090@64237@g' -i tests/socket.tst
    sed -i 's@/bin/pwd@${coreutils}&@' src/clisp-link.in
    sed -i 's@1\.16\.2@${automake.version}@' src/aclocal.m4
    find . -type f | xargs sed -e 's/-lICE/-lXau &/' -i
  '';

  configureFlags = [
    "builddir"
  ]
  ++ lib.optional (!dllSupport) "--without-dynamic-modules"
  ++ lib.optional (readline != null) "--with-readline"
  ++ lib.optional (ffcallAvailable && (libffi != null)) "--with-dynamic-ffi"
  ++ lib.optional ffcallAvailable "--with-ffcall"
  ++ lib.optional (!ffcallAvailable) "--without-ffcall"
  ++ builtins.map (x: " --with-module=" + x) withModules
  ++ lib.optional threadSupport "--with-threads=POSIX_THREADS";

  preBuild = ''
    sed -e '/avcall.h/a\#include "config.h"' -i src/foreign.d
    sed -i -re '/ cfree /d' -i modules/bindings/glibc/linux.lisp
    cd builddir
  '';

  hardeningDisable = [ "pie" ];

  doCheck = true;

  # Replace broken symlinks (pointing to /build/) with copies of the actual files
  preFixup = ''
    for link in $(find "$out" -type l); do
      target=$(readlink "$link")
      case "$target" in
        /build/*)
          if [ -f "$target" ]; then
            rm "$link"
            cp "$target" "$link"
          fi
          ;;
      esac
    done
  '';

  env.NIX_CFLAGS_COMPILE = "-O0 -falign-functions=${
    if stdenv.hostPlatform.is64bit then "8" else "4"
  }";

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = "http://clisp.org";
    mainProgram = "clisp";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
