{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  chromaprint,
  gettext,
  gst_all_1,
  qt5,
  libsForQt5,
  taglib_1,
  fftw,
  glew,
  sqlite,
  libpulseaudio,
  gvfs,
  protobuf,
  pkg-config,
  sparsehash,
  util-linux,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clementine";
  version = "1.4.1-60-g1a3e8b56f";

  src = fetchFromGitHub {
    owner = "clementine-player";
    repo = "Clementine";
    tag = finalAttrs.version;
    hash = "sha256-FRgTi1Qxzp0vJASNpyANqh4rJX4caxEr0CZOnTHA3Kw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt5.wrapQtAppsHook
    util-linux
  ];

  buildInputs = [
    boost
    chromaprint
    fftw
    gettext
    glew
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gvfs
    libpulseaudio
    protobuf
    qt5.qtbase
    qt5.qtx11extras
    qt5.qttools
    sqlite
    taglib_1
    alsa-lib
    sparsehash
  ];

  postPatch = ''
    sed -i src/CMakeLists.txt \
      -e 's,-Werror,,g' \
      -e 's,-Wno-unknown-warning-option,,g' \
      -e 's,-Wno-unused-private-field,,g'
    sed -i CMakeLists.txt \
      -e 's,libprotobuf.a,protobuf,g'

    substituteInPlace 3rdparty/{qsqlite,qtsingleapplication,qtiocompressor,qxt}/CMakeLists.txt \
      cmake/{ParseArguments.cmake,Translations.cmake}                                          \
      tests/CMakeLists.txt gst/moodbar/CMakeLists.txt                                          \
      --replace-fail                                                                           \
        "cmake_minimum_required(VERSION 3.0.0)" \
        "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace 3rdparty/libmygpo-qt5/CMakeLists.txt --replace-fail \
      "cmake_minimum_required( VERSION 3.0.0 FATAL_ERROR )" \
      "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace CMakeLists.txt --replace-fail \
        "cmake_policy(SET CMP0053 OLD)" \
        ""
  '';

  preConfigure = ''
    rm -rf ext/{,lib}clementine-spotifyblob
  '';

  cmakeFlags = [
    (lib.cmakeFeature "FORCE_GIT_REVISION" "1.3.1")
    (lib.cmakeBool "USE_SYSTEM_PROJECTM" false)
    (lib.cmakeBool "SPOTIFY_BLOB" false)
  ];

  dontWrapQtApps = true;

  postInstall = ''
    wrapQtApp $out/bin/clementine \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  meta = {
    homepage = "https://www.clementine-player.org";
    description = "Multiplatform music player";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "clementine";
  };
})
