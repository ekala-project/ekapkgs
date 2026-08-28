{
  lib,
  stdenv,
  fetchgit,
  fetchzip,
  alsa-lib,
  aubio,
  boost,
  cairomm,
  cppunit,
  curl,
  dbus,
  doxygen,
  ffmpeg,
  fftw,
  fftwSinglePrec,
  flac,
  fluidsynth,
  glibc,
  glibmm,
  graphviz,
  harvid ? null,
  hidapi,
  installShellFiles,
  itstool,
  kissfft ? null,
  libarchive,
  libjack2,
  liblo,
  libltc,
  libogg,
  libpulseaudio,
  librdf_rasqal,
  libsamplerate,
  libsigcxx,
  libsndfile,
  libusb1,
  libuv,
  libwebsockets,
  libxi,
  libxml2,
  libxslt,
  lilv,
  lrdf ? null,
  lv2,
  makeWrapper,
  pango,
  pangomm,
  perl,
  pkg-config,
  python3,
  qm-dsp ? null,
  readline,
  rubberband,
  serd,
  sord,
  soundtouch,
  sratom,
  suil,
  taglib,
  vamp-plugin-sdk,
  wafHook,
  which,
  xjadeo ? null,
  libxrandr,
  libxinerama,
  libjpeg,
  optimize ? true,
  videoSupport ? false,
}:

let
  bundledContent = fetchzip {
    url = "https://web.archive.org/web/20221026200824/http://stuff.ardour.org/loops/ArdourBundledMedia.zip";
    hash = "sha256-IbPQWFeyMuvCoghFl1ZwZNNcSvLNsH84rGArXnw+t7A=";
    stripRoot = false;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ardour";
  version = "9.7";

  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    tag = finalAttrs.version;
    hash = "sha256-6gtlnk/oPXWJcN5tcb1r7dXyLpHPTSJwd8VfOjjFnWQ=";
  };

  patches = [
    ./as-flags.patch
    ./default-plugin-search-paths.patch
  ];

  postPatch =
    let
      majorVersion = lib.versions.major finalAttrs.version;
    in
    ''
      printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = "${finalAttrs.version}"; const char* date = ""; }\n' > libs/ardour/revision.cc
      patchShebangs ./tools/
      substituteInPlace libs/ardour/video_tools_paths.cc \
        --replace-fail 'ffmpeg_exe = X_("");' 'ffmpeg_exe = X_("${lib.getExe ffmpeg}");' \
        --replace-fail 'ffprobe_exe = X_("");' 'ffprobe_exe = X_("${lib.getExe' ffmpeg "ffprobe"}");'

      sed 's|/usr/include/libintl.h|${lib.getInclude glibc.dev}/include/libintl.h|' -i wscript
    '';

  nativeBuildInputs = [
    doxygen
    graphviz
    installShellFiles
    itstool
    makeWrapper
    perl
    pkg-config
    python3
    wafHook
  ];

  buildInputs = [
    alsa-lib
    aubio
    boost
    cairomm
    cppunit
    curl
    dbus
    ffmpeg
    fftw
    fftwSinglePrec
    flac
    fluidsynth
    glibmm
    hidapi
    itstool
    libarchive
    libjack2
    libjpeg
    liblo
    libltc
    libogg
    libpulseaudio
    librdf_rasqal
    libsamplerate
    libsigcxx
    libsndfile
    libusb1
    libuv
    libwebsockets
    libxi
    libxinerama
    libxml2
    libxrandr
    libxslt
    lilv
    lv2
    pango
    pangomm
    perl
    python3
    readline
    rubberband
    serd
    sord
    soundtouch
    sratom
    suil
    taglib
    vamp-plugin-sdk
  ]
  ++ lib.optional (kissfft != null) kissfft
  ++ lib.optional (lrdf != null) lrdf
  ++ lib.optional (qm-dsp != null) qm-dsp;

  wafConfigureFlags = [
    "--cxx17"
    "--docs"
    "--no-phone-home"
    "--ptformat"
    "--freedesktop"
  ]
  ++ lib.optional finalAttrs.finalPackage.doCheck "--test"
  ++ lib.optional optimize "--optimize";

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-I${lib.getInclude serd}/include/serd-0"
      "-I${lib.getInclude sratom}/include/sratom-0"
      "-I${lib.getInclude sord}/include/sord-0"
      "-D_GNU_SOURCE"
    ];
    LINKFLAGS = "-lpthread";
  };

  postInstall =
    let
      majorVersion = lib.versions.major finalAttrs.version;
    in
    ''
      installManPage ardour.1

      # wscript does not install these for some reason
      install -vDm 644 "build/gtk2_ardour/ardour.xml" \
        -t "$out/share/mime/packages"
      install -vDm 644 "build/gtk2_ardour/ardour${majorVersion}.desktop" \
        -t "$out/share/applications"
      for size in 16 22 32 48 256 512; do
        install -vDm 644 "gtk2_ardour/resources/Ardour-icon_''${size}px.png" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/ardour${majorVersion}.png"
      done

      # install additional bundled beats, chords and progressions
      cp -rp "${bundledContent}"/* "$out/share/ardour${majorVersion}/media"
    '';

  doCheck = true;

  checkPhase = ''
    runHook preHook
    ./waf test
    runHook postHook
  '';

  meta = {
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Ardour is a digital audio workstation (DAW), you can use it to
      record, edit and mix multi-track audio and midi. Produce your
      own CDs. Mix video soundtracks. Experiment with new ideas about
      music and sound.

      Please consider supporting the ardour project financially:
      https://community.ardour.org/donate
    '';
    homepage = "https://ardour.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ardour9";
    platforms = lib.platforms.linux;
  };
})
