{
  lib,
  stdenv,
  targetPackages,
  fetchurl,
  pkg-config,
  perl,
  texinfo,
  setupDebugInfoDirs,
  buildPackages,
  bashNonInteractive,
  readline,
  expat,
  libipt,
  zlib,
  zstd,
  xz,
  dejagnu,
  sourceHighlight,
  xxhash,
  ncurses,
  gmp,
  mpfr,
  pythonSupport ? stdenv.hostPlatform == stdenv.buildPlatform,
  python3,
  enableDebuginfod ? lib.meta.availableOn stdenv.hostPlatform elfutils,
  elfutils,
  hostCpuOnly ? false,
  safePaths ? [
    "$debugdir"
    "$datadir/auto-load"
    (lib.getLib targetPackages.stdenv.cc.cc)
  ],
}:

let
  inherit (lib)
    optional
    optionals
    optionalString
    withFeature
    enableFeature
    withFeatureAs
    ;
  targetPrefix = optionalString (
    stdenv.targetPlatform != stdenv.hostPlatform
  ) "${stdenv.targetPlatform.config}-";
  pname = targetPrefix + "gdb" + optionalString hostCpuOnly "-host-cpu-only";
in

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "17.2";

  src = fetchurl {
    url = "mirror://gnu/gdb/gdb-${finalAttrs.version}.tar.xz";
    hash = "sha256-HANsDXLks9H7XJTIhjKt1vnXb018TS6nk8EqnxmjIow=";
  };

  postPatch = optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace sim/erc32/erc32.c  --replace-fail sys/fcntl.h fcntl.h
    substituteInPlace sim/erc32/interf.c  --replace-fail sys/fcntl.h fcntl.h
    substituteInPlace sim/erc32/sis.c  --replace-fail sys/fcntl.h fcntl.h
    substituteInPlace sim/ppc/emul_unix.c --replace-fail sys/termios.h termios.h
  '';

  patches = [
    ./debug-info-from-env.patch
  ];

  nativeBuildInputs = [
    pkg-config
    texinfo
    perl
    setupDebugInfoDirs
  ]
  ++ optional pythonSupport python3;

  buildInputs = [
    bashNonInteractive
    ncurses
    readline
    expat
    libipt
    zlib
    zstd
    xz
    sourceHighlight
    xxhash
    dejagnu
    mpfr
    gmp
  ]
  ++ optional enableDebuginfod (elfutils.override { enableDebuginfod = true; });

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;
  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  preConfigure = ''
    rm gdb/doc/*.info*
    rm gdb/doc/*.5
    rm gdb/doc/*.1
    rm gdb/doc/GDBvn.texi

    mkdir _build
    cd _build
  '';
  configureScript = "../configure";

  configureFlags = [
    "--program-prefix=${targetPrefix}"
    (enableFeature false "werror")
    (enableFeature true "64-bit-bfd")
    (enableFeature false "install-libbfd")
    (enableFeature true "tui")
    (withFeature true "curses")
    (enableFeature false "shared")
    (enableFeature true "static")
    (withFeature true "system-readline")
    (withFeature true "system-zlib")
    (withFeature true "expat")
    (withFeatureAs true "libexpat-prefix" expat.dev)
    (withFeatureAs true "gmp" gmp.dev)
    (withFeatureAs true "mpfr" mpfr.dev)
    (withFeature pythonSupport "python")
    (enableFeature false "sim")
    (withFeatureAs true "system-gdbinit" "/etc/gdb/gdbinit")
    (withFeatureAs true "system-gdbinit-dir" "/etc/gdb/gdbinit.d")
    (withFeatureAs true "auto-load-safe-path" (builtins.concatStringsSep ":" safePaths))
    (withFeature enableDebuginfod "debuginfod")
    (enableFeature (!stdenv.hostPlatform.isMusl) "nls")
  ]
  ++ optional (!hostCpuOnly) "--enable-targets=all";

  postInstall = ''
    rm -v $out/share/info/bfd.info
  '';

  meta = {
    description = "GNU Project debugger";
    mainProgram = "${targetPrefix}gdb";
    homepage = "https://www.gnu.org/software/gdb/";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
  };
})
