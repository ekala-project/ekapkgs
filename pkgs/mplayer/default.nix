{
  lib,
  stdenv,
  fetchsvn,
  pkg-config,
  freetype,
  yasm,
  ffmpeg_7,
  aalibSupport ? true,
  aalib ? null,
  fontconfigSupport ? true,
  fontconfig,
  freefont_ttf,
  fribidiSupport ? true,
  fribidi,
  x11Support ? true,
  libx11,
  libxext,
  libGLU,
  libGL,
  xineramaSupport ? true,
  libxinerama ? null,
  xvSupport ? true,
  libxv ? null,
  alsaSupport ? true,
  alsa-lib,
  screenSaverSupport ? true,
  libxscrnsaver ? null,
  vdpauSupport ? false,
  libvdpau ? null,
  cddaSupport ? true,
  cdparanoia,
  dvdnavSupport ? true,
  libdvdnav_4_2_1 ? null,
  dvdreadSupport ? true,
  libdvdread,
  bluraySupport ? true,
  libbluray,
  amrSupport ? false,
  amrnb ? null,
  amrwb ? null,
  cacaSupport ? true,
  libcaca ? null,
  lameSupport ? true,
  lame,
  speexSupport ? true,
  speex,
  theoraSupport ? true,
  libtheora,
  x264Support ? false,
  x264,
  jackaudioSupport ? false,
  libjack2 ? null,
  pulseSupport ? false,
  libpulseaudio ? null,
  bs2bSupport ? false,
  libbs2b,
  v4lSupport ? false,
  libv4l,
  libpngSupport ? true,
  libpng,
  libjpegSupport ? true,
  libjpeg,
  buildPackages,
}:

assert xineramaSupport -> x11Support;
assert xvSupport -> x11Support;

let
  crossBuild = stdenv.hostPlatform != stdenv.buildPlatform;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "mplayer";
  version = "1.5-unstable-2024-12-21";

  src = fetchsvn {
    url = "svn://svn.mplayerhq.hu/mplayer/trunk";
    rev = "38668";
    hash = "sha256-ezWYBkhiSBgf/SeTrO6sKGbL/IrX+82KXCIlqYMEtgY=";
  };

  prePatch = ''
    echo "${finalAttrs.version}" > VERSION
    sed -i /^_install_strip/d configure

    rm -rf ffmpeg
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    pkg-config
    yasm
  ]
  ++ lib.optionals (cacaSupport && libcaca != null) [
    libcaca
  ];
  buildInputs = [
    freetype
    ffmpeg_7
  ]
  ++ lib.optional (aalibSupport && aalib != null) aalib
  ++ lib.optional fontconfigSupport fontconfig
  ++ lib.optional fribidiSupport fribidi
  ++ lib.optionals x11Support [
    libx11
    libxext
    libGLU
    libGL
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional (xvSupport && libxv != null) libxv
  ++ lib.optional theoraSupport libtheora
  ++ lib.optional (cacaSupport && libcaca != null) libcaca
  ++ lib.optional (xineramaSupport && libxinerama != null) libxinerama
  ++ lib.optional (dvdnavSupport && libdvdnav_4_2_1 != null) libdvdnav_4_2_1
  ++ lib.optional dvdreadSupport libdvdread
  ++ lib.optional bluraySupport libbluray
  ++ lib.optional cddaSupport cdparanoia
  ++ lib.optional (jackaudioSupport && libjack2 != null) libjack2
  ++ lib.optionals (amrSupport && amrnb != null && amrwb != null) [
    amrnb
    amrwb
  ]
  ++ lib.optional x264Support x264
  ++ lib.optional (pulseSupport && libpulseaudio != null) libpulseaudio
  ++ lib.optional (screenSaverSupport && libxscrnsaver != null) libxscrnsaver
  ++ lib.optional lameSupport lame
  ++ lib.optional (vdpauSupport && libvdpau != null) libvdpau
  ++ lib.optional speexSupport speex
  ++ lib.optional libpngSupport libpng
  ++ lib.optional libjpegSupport libjpeg
  ++ lib.optional bs2bSupport libbs2b
  ++ lib.optional v4lSupport libv4l;

  strictDeps = true;

  configurePlatforms = [ ];
  configureFlags = [
    (lib.enableFeature true "freetype")
    (lib.enableFeature fontconfigSupport "fontconfig")
    (lib.enableFeature x11Support "x11")
    (lib.enableFeature x11Support "gl")
    (lib.enableFeature xineramaSupport "xinerama")
    (lib.enableFeature xvSupport "xv")
    (lib.enableFeature alsaSupport "alsa")
    (lib.enableFeature screenSaverSupport "xss")
    (lib.enableFeature vdpauSupport "vdpau")
    (lib.enableFeature cddaSupport "cdparanoia")
    (lib.enableFeature (dvdnavSupport && libdvdnav_4_2_1 != null) "dvdnav")
    (lib.enableFeature bluraySupport "bluray")
    (lib.enableFeature amrSupport "libopencore_amrnb")
    (lib.enableFeature cacaSupport "caca")
    (lib.enableFeature lameSupport "mp3lame")
    (lib.enableFeature (!lameSupport) "mp3lame-lavc")
    (lib.enableFeature speexSupport "speex")
    (lib.enableFeature theoraSupport "theora")
    (lib.enableFeature x264Support "x264")
    (lib.enableFeature (!x264Support) "x264-lavc")
    (lib.enableFeature pulseSupport "pulse")
    (lib.enableFeature v4lSupport "v4l2")
    (lib.enableFeature v4lSupport "tv-v4l2")
    (lib.enableFeature v4lSupport "radio")
    (lib.enableFeature v4lSupport "radio-v4l2")
    (lib.enableFeature v4lSupport "radio-capture")
    (lib.enableFeature false "xanim")
    (lib.enableFeature false "xvid")
    (lib.enableFeature false "xvid-lavc")
    (lib.enableFeature false "ossaudio")
    (lib.enableFeature false "ffmpeg_a")
    "--yasm=${buildPackages.yasm}/bin/yasm"
    "--target=${stdenv.hostPlatform.config}"
  ]
  ++ lib.optional (!jackaudioSupport) "--disable-jack"
  ++ lib.optional (stdenv.hostPlatform.isx86 && !crossBuild) "--enable-runtime-cpudetection"
  ++ lib.optional fribidiSupport "--enable-fribidi"
  ++ lib.optional (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch64) "--enable-vidix"
  ++ lib.optional stdenv.hostPlatform.isLinux "--enable-fbdev"
  ++ lib.optionals crossBuild [
    "--enable-cross-compile"
    "--disable-vidix-pcidb"
    "--with-vidix-drivers=no"
  ];

  preConfigure = ''
    configureFlagsArray+=(
      "--cc=$CC"
      "--host-cc=$CC_FOR_BUILD"
      "--as=$AS"
      "--nm=$NM"
      "--ar=$AR"
      "--ranlib=$RANLIB"
      "--windres=$WINDRES"
    )
  '';

  postConfigure = ''
    echo CONFIG_MPEGAUDIODSP=yes >> config.mak
  '';

  env = {
    NIX_LDFLAGS = toString (
      lib.optionals fontconfigSupport [
        "-lfontconfig"
      ]
      ++ lib.optionals fribidiSupport [
        "-lfribidi"
      ]
      ++ lib.optionals x11Support [
        "-lX11"
        "-lXext"
      ]
      ++ lib.optionals x264Support [
        "-lx264"
      ]
      ++ [ "-lfreetype" ]
    );
  };

  installTargets = [ "install" ] ++ lib.optional x11Support "install-gui";

  enableParallelBuilding = true;

  postInstall = lib.optionalString (!fontconfigSupport) ''
    mkdir -p $out/share/mplayer
    cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf
    if test -f $out/share/applications/mplayer.desktop ; then
      echo "NoDisplay=True" >> $out/share/applications/mplayer.desktop
    fi
  '';

  __structuredAttrs = true;

  meta = {
    description = "Movie player that supports many video formats";
    homepage = "http://mplayerhq.hu";
    license = lib.licenses.gpl2Only;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
