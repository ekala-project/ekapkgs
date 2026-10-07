{
  lib,
  stdenv,
  fetchhg,
  boost,
  charls,
  civetweb,
  cmake,
  curl,
  dcmtk,
  gtest,
  jsoncpp,
  libjpeg,
  libpng,
  libuuid,
  log4cplus,
  lua,
  openssl,
  protobuf,
  pugixml,
  python3,
  sqlite,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orthanc";
  version = "1.12.11";

  src = fetchhg {
    url = "https://orthanc.uclouvain.be/hg/orthanc/";
    rev = "Orthanc-${finalAttrs.version}";
    hash = "sha256-EoohVYrnGN3dJUlXAd+10glcKA0AdZSyQ3wy2luycMQ=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  sourceRoot = "${finalAttrs.src.name}/OrthancServer";

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    protobuf
    python3
    unzip
  ];

  buildInputs = [
    protobuf
    boost
    charls
    civetweb
    curl
    dcmtk
    gtest
    jsoncpp
    libjpeg
    libpng
    libuuid
    log4cplus
    lua
    openssl
    pugixml
    sqlite
  ];

  strictDeps = true;


  cmakeEntries = {
    DCMTK_DICTIONARY_DIR_AUTO = "${dcmtk}/share/dcmtk-${dcmtk.version}";
    DCMTK_LIBRARIES = "dcmjpls;oflog;ofstd";
    CMAKE_BUILD_TYPE = "Release";
    BUILD_CONNECTIVITY_CHECKS = false;
    UNIT_TESTS_WITH_HTTP_CONNEXIONS = false;
    STANDALONE_BUILD = true;
    USE_SYSTEM_BOOST = true;
    USE_SYSTEM_CIVETWEB = true;
    USE_SYSTEM_DCMTK = true;
    USE_SYSTEM_GOOGLE_TEST = true;
    USE_SYSTEM_JSONCPP = true;
    USE_SYSTEM_LIBICONV = true;
    USE_SYSTEM_LIBJPEG = true;
    USE_SYSTEM_LIBPNG = true;
    USE_SYSTEM_LUA = true;
    USE_SYSTEM_OPENSSL = true;
    USE_SYSTEM_PROTOBUF = true;
    USE_SYSTEM_PUGIXML = true;
    USE_SYSTEM_SQLITE = true;
    USE_SYSTEM_UUID = true;
    USE_SYSTEM_ZLIB = true;
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-builtin-macro-redefined";

  postInstall = ''
    mkdir -p $doc/share/doc/orthanc
    cp -r $src/OrthancServer/Resources/Samples $doc/share/doc/orthanc/Samples
    cp -r $src/OrthancServer/Plugins/Samples $doc/share/doc/orthanc/OrthancPluginSamples
  '';

  meta = {
    description = "Lightweight, RESTful DICOM server for healthcare and medical research";
    homepage = "https://www.orthanc-server.com/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Orthanc";
    platforms = lib.platforms.linux;
  };
})
