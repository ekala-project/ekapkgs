{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  wrapGAppsHook3,
  pkg-config,
  python3,
  gettext,
  file,
  libvorbis,
  libmad,
  libjack2,
  lv2,
  lilv,
  mpg123,
  opusfile,
  rapidjson,
  serd,
  sord,
  sqlite,
  sratom,
  suil,
  libsndfile,
  soxr,
  flac,
  lame,
  twolame,
  expat,
  libid3tag,
  libopus,
  libuuid,
  ffmpeg,
  soundtouch,
  portaudio,
  portmidi,
  linuxHeaders,
  alsa-lib,
  at-spi2-core,
  dbus,
  libepoxy,
  libxdmcp,
  libxtst,
  libpthread-stubs,
  libsbsms_2_3_0 ? null,
  libselinux,
  libsepol,
  libxkbcommon,
  util-linux,
  wavpack,
  wxwidgets,
  gtk3,
}:

let
  # Use ffmpeg without libaom to avoid nasm build issues
  ffmpegFixed = ffmpeg.override { withAom = false; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "audacity";
  version = "3.7.8";

  src = fetchFromGitHub {
    owner = "audacity";
    repo = "audacity";
    rev = "Audacity-${finalAttrs.version}";
    hash = "sha256-Vp3Nx3LuNu5fqeLF6dvZ9/hhkoUCu0eCAdIEDtS1IwU=";
  };

  patches = [
    ./rapidjson.patch
  ];

  postPatch = ''
    mkdir src/private
    substituteInPlace libraries/lib-files/FileNames.cpp \
      --replace-fail /usr/include/linux/magic.h ${linuxHeaders}/include/linux/magic.h
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gettext
    pkg-config
    python3
    makeWrapper
    wrapGAppsHook3
    linuxHeaders
  ];

  buildInputs = [
    expat
    ffmpegFixed
    file
    flac
    gtk3
    lame
    libid3tag
    libjack2
    libmad
    libopus
    libsndfile
    libvorbis
    lilv
    lv2
    mpg123
    opusfile
    portmidi
    rapidjson
    serd
    sord
    soundtouch
    soxr
    sqlite
    sratom
    suil
    twolame
    portaudio
    wavpack
    alsa-lib
    at-spi2-core
    dbus
    libepoxy
    libxdmcp
    libxtst
    libpthread-stubs
    libxkbcommon
    libselinux
    libsepol
    libuuid
    util-linux
  ]
  ++ lib.optionals (libsbsms_2_3_0 != null) [ libsbsms_2_3_0 ]
  ++ [ wxwidgets ];

  cmakeFlags = [
    "-DAUDACITY_BUILD_LEVEL=2"
    "-DAUDACITY_REV_LONG=nixpkgs"
    "-DAUDACITY_REV_TIME=nixpkgs"
    "-DDISABLE_DYNAMIC_LOADING_FFMPEG=ON"
    "-Daudacity_conan_enabled=Off"
    "-Daudacity_use_ffmpeg=loaded"
    "-Daudacity_has_vst3=Off"
    "-Daudacity_has_crashreports=Off"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  preBuild = ''
    export LD_LIBRARY_PATH=$PWD/Release/lib/audacity
  '';

  doCheck = false;

  dontWrapGApps = true;

  postFixup = ''
    wrapProgram "$out/bin/audacity" \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "$out/lib/audacity":${lib.makeLibraryPath [ ffmpegFixed ]} \
      --suffix AUDACITY_MODULES_PATH : "$out/lib/audacity/modules" \
      --suffix AUDACITY_PATH : "$out/share/audacity" \
      --set-default GDK_BACKEND x11
  '';

  meta = {
    description = "Sound editor with graphical UI";
    mainProgram = "audacity";
    homepage = "https://www.audacityteam.org";
    changelog = "https://github.com/audacity/audacity/releases";
    license = with lib.licenses; [
      gpl2Plus
      gpl3
      cc-by-30
    ];
    platforms = lib.platforms.linux;
  };
})
