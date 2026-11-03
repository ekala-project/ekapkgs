{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
  perl,
  taglib_1,
  taglib_extras,
  ffmpeg,
  speex,
  mpg123,
  libmtp,
  libvlc,
  udisks,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cantata";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "nullobsi";
    repo = "cantata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jwIsuNgsd1TFb1Zkyen/AulGQfVY2RWKfAJaWvg4WMI=";
  };

  postPatch = ''
    patchShebangs playlists
  '';

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    qt6.qtmultimedia
    kdePackages.karchive
    kdePackages.kitemviews
    (perl.withPackages (ppkgs: [ ppkgs.URI ]))
    taglib_1
    taglib_extras
    ffmpeg
    speex
    mpg123
    libmtp
    libvlc
    udisks
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DENABLE_TAGLIB=ON"
    "-DENABLE_TAGLIB_EXTRAS=ON"
    "-DENABLE_HTTP_STREAM_PLAYBACK=ON"
    "-DENABLE_FFMPEG=ON"
    "-DENABLE_MPG123=ON"
    "-DENABLE_SPEEXDSP=ON"
    "-DENABLE_MTP=ON"
    "-DENABLE_LIBVLC=ON"
    "-DENABLE_UDISKS2=ON"
    "-DENABLE_DYNAMIC=ON"
    "-DENABLE_DEVICES_SUPPORT=ON"
    "-DENABLE_HTTP_SERVER=ON"
    "-DENABLE_HTTPS_SUPPORT=ON"
    "-DENABLE_ONLINE_SERVICES=ON"
    "-DENABLE_STREAMS=ON"
    "-DENABLE_CDPARANOIA=OFF"
    "-DENABLE_CDDB=OFF"
    "-DENABLE_LAME=OFF"
    "-DENABLE_MUSICBRAINZ=OFF"
  ];

  meta = {
    description = "Graphical client for MPD";
    mainProgram = "cantata";
    homepage = "https://github.com/nullobsi/cantata";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
