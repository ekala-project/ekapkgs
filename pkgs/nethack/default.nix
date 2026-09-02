{
  stdenv,
  lib,
  fetchurl,
  coreutils,
  groff,
  ncurses,
  gzip,
  less,
  bash,
  pkg-config,
  copyDesktopItems ? null,
  makeDesktopItem ? null,
}:

let
  hint = if stdenv.hostPlatform.isLinux then "linux.500" else "unix";
  userDir = "~/.config/nethack";
  binPath = lib.makeBinPath [
    coreutils
    less
  ];
in

stdenv.mkDerivation (finalAttrs: {
  version = "5.0.0";
  pname = "nethack";

  src = fetchurl {
    url = "https://nethack.org/download/${finalAttrs.version}/nethack-${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }-src.tgz";
    sha256 = "sha256-KVm3iGqsdhhbkK6gyfgNFDQ/YE3grpaz3Sp2D3qzvek=";
  };

  postUnpack =
    let
      lua548 = fetchurl {
        url = "https://www.lua.org/ftp/lua-5.4.8.tar.gz";
        hash = "sha256-TxjdrhVOeT5G7qtyfFnvHAwMK3ROe5QhlxDXb1MGKa4=";
      };
    in
    ''
      mkdir -p NetHack-${finalAttrs.version}/lib
      tar zxf ${lua548} -C NetHack-${finalAttrs.version}/lib
    '';

  buildInputs = [
    ncurses
  ];

  nativeBuildInputs = [
    copyDesktopItems
    groff
    pkg-config
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "WANT_WIN_TTY=1"
    "WANT_WIN_CURSES=1"
    "WANT_DEFAULT=curses"
  ];

  postPatch = ''
    sed -e '/^ *cd /d' -i sys/unix/nethack.sh
    sed -e '/rm -f $(MAKEDEFS)/d' -i sys/unix/Makefile.src
    sed \
      -e 's,^CFLAGS=-g,CFLAGS=,' \
      -e 's,/bin/gzip,${gzip}/bin/gzip,g' \
      -e 's,^WINTTYLIB=.*,WINTTYLIB=-lncurses,' \
      -e 's,NHCFLAGS+=-DCOMPRESS[^ ]*,NHCFLAGS+=-DCOMPRESS=\\"${gzip}/bin/gzip\\" \\\
        -DCOMPRESS_EXTENSION=\\".gz\\",' \
      -i sys/unix/hints/linux.500
    sed \
      -E 's/^(GDBPATH|GREPPATH)/#\1/' \
      -i sys/unix/sysconf
    sed \
      -e 's,^HACKDIR=.*$,HACKDIR=\$(PREFIX)/games/lib/\$(GAME)dir,' \
      -e 's,^SHELLDIR=.*$,SHELLDIR=\$(PREFIX)/games,' \
      -e 's,^CFLAGS+=-DCRASHREPORT,#CFLAGS+=-DCRASHREPORT,' \
      -e 's,^NHCFLAGS+=-DGREPPATH,#NHCFLAGS+=-DGREPPATH,' \
      -e 's,/usr/bin/true,${coreutils}/bin/true,g' \
      -e 's,NHCFLAGS+=-DCOMPRESS[^ ]*,NHCFLAGS+=-DCOMPRESS=\\"${gzip}/bin/gzip\\" \\\
        -DCOMPRESS_EXTENSION=\\".gz\\",' \
      -i sys/unix/hints/macOS.500
    sed -e '/define CHDIR/d' \
        -i include/config.h
    sed \
      -e 's,AR=.*,AR := $(AR) rcu,' \
      -e 's,RANLIB=.*,RANLIB := $(RANLIB),' \
      -i lib/lua-5.4.8/src/Makefile
    sed \
      -e 's,AR =.*,AR := $(AR),' \
      -i sys/unix/Makefile.src
  '';

  configurePhase = ''
    pushd sys/unix
    sh setup.sh hints/${hint}
    popd
  '';

  # https://github.com/NixOS/nixpkgs/issues/294751
  enableParallelBuilding = false;

  postInstall = ''
    mkdir -p $out/games/lib/nethackuserdir
    for i in xlogfile logfile perm record save; do
      mv $out/games/lib/nethackdir/$i $out/games/lib/nethackuserdir
    done

    mkdir -p $out/bin
    cat <<EOF >$out/bin/nethack
    #! ${lib.getExe bash} -e
    PATH=${binPath}:\$PATH

    if [ ! -d ${userDir} ]; then
      mkdir -p ${userDir}
      cp -r $out/games/lib/nethackuserdir/* ${userDir}
      chmod -R +w ${userDir}
    fi

    RUNDIR=\$(mktemp -d)

    cleanup() {
      rm -rf \$RUNDIR
    }
    trap cleanup EXIT
    cd \$RUNDIR
    for i in ${userDir}/*; do
      ln -s \$i \$(basename \$i)
    done
    for i in $out/games/lib/nethackdir/*; do
      ln -s \$i \$(basename \$i)
    done
    set +e
    $out/games/nethack "\$@"
    if [[ \$? -gt 128 ]]; then
      echo "nethack exited abnormally, attempting to recover save file..."
      ./recover -d . ?lock.0
    fi
    EOF
    chmod +x $out/bin/nethack
    ${lib.optionalString (stdenv.buildPlatform == stdenv.hostPlatform) ''
      install -Dm 555 util/makedefs -t $out/libexec/nethack/
      install -Dm 555 util/dlb -t $out/libexec/nethack/
    ''}
  '';

  meta = {
    description = "Rogue-like game";
    homepage = "http://nethack.org/";
    license = lib.licenses.ngpl;
    platforms = lib.platforms.unix;
    mainProgram = "nethack";
  };
})
