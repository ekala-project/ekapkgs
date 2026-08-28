{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libjack2,
  ncurses,
  alsa-lib,
  buildPackages,

  ## Additional optional output modes
  enableVorbis ? false,
  libvorbis,
}:

stdenv.mkDerivation rec {
  pname = "timidity";
  version = "2.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/timidity/TiMidity++-${version}.tar.bz2";
    sha256 = "1xf8n6dqzvi6nr2asags12ijbj1lwk1hgl3s27vm2szib8ww07qn";
  };

  patches = [
    ./timidity-iA-Oj.patch
    ./configure-compat.patch
  ];

  postPatch = ''
    substituteInPlace configure \
      --replace-fail "\$(pkg-config" "\$(\$PKG_CONFIG"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals enableVorbis [
    libvorbis
  ];

  enabledOutputModes = [
    "jack"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "oss"
    "alsa"
  ]
  ++ lib.optionals enableVorbis [
    "vorbis"
  ];

  configureFlags = [
    "--enable-ncurses"
    ("--enable-audio=" + builtins.concatStringsSep "," enabledOutputModes)
    "lib_cv_va_copy=yes"
    "lib_cv___va_copy=yes"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--enable-alsaseq"
    "--with-default-output=alsa"
    "lib_cv_va_val_copy=yes"
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  instruments = fetchurl {
    url = "https://courses.cs.umbc.edu/pub/midia/instruments.tar.gz";
    sha256 = "0lsh9l8l5h46z0y8ybsjd4pf6c22n33jsjvapfv3rjlfnasnqw67";
  };

  preBuild = ''
    # calcnewt has to be built with the host compiler.
    ${buildPackages.stdenv.cc}/bin/cc -o timidity/calcnewt -lm timidity/calcnewt.c
    # Remove dependencies of calcnewt so it doesn't try to remake it.
    sed -i 's/^\(calcnewt\$(EXEEXT):\).*/\1/g' timidity/Makefile
  '';

  # Fix build with gcc15
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  postInstall = ''
    mkdir -p $out/share/timidity/;
    cp ${./timidity.cfg} $out/share/timidity/timidity.cfg
    substituteAllInPlace $out/share/timidity/timidity.cfg
    tar --strip-components=1 -xf $instruments -C $out/share/timidity/
    chmod -Rh u+rwX $out/share/timidity/
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/timidity/";
    license = lib.licenses.gpl2Plus;
    description = "Software MIDI renderer";
    platforms = lib.platforms.unix;
    mainProgram = "timidity";
  };
}
