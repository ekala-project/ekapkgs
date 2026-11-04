{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  catch2_3,
  cmake,
  cppzmq,
  doxygen,
  ffmpeg,
  glib,
  imagemagick,
  jsoncpp,
  libopenshot-audio,
  opencv4,
  pipewire,
  pkg-config,
  protobuf,
  python3,
  qt6,
  swig,
  zeromq,
  resvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenshot";
  version = "0.7.0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    rev = "eac81cf91555438c54fbadef7fdd05bf803f26ee";
    hash = "sha256-XeEXvKi5O/0J6rEc8rZs4+x/ImF4X0GFw/dOWn9HCCQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    doxygen
    pkg-config
    protobuf
    swig
  ];

  buildInputs = [
    catch2_3
    cppzmq
    ffmpeg
    imagemagick
    jsoncpp
    libopenshot-audio
    opencv4
    protobuf
    python3
    qt6.qtbase
    qt6.qtmultimedia
    zeromq
    resvg
    alsa-lib
    glib
    pipewire
  ];

  strictDeps = true;

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_RUBY" false)
    (lib.cmakeBool "ENABLE_PYTHON" true)
    "-DUSE_QT6=ON"
  ];

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor library";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
