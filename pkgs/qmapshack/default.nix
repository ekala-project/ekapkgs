{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  alglib,
  asmjit,
  blend2d,
  gdal,
  proj,
  routino,
  quazip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmapshack";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "Maproom";
    repo = "qmapshack";
    tag = "V_${finalAttrs.version}";
    hash = "sha256-mayPiVV9F6yxDnRyNLrZSiDSPsIRILsaF53Qm7SISg0=";
  };

  patches = [ ./dont_fetch_dependencies.patch ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alglib
    asmjit
    blend2d
    gdal
    proj
    routino
    qt6.qtwebengine
    quazip
  ];

  cmakeEntries = {
    ALGLIB_INCLUDE_DIRS = "${alglib}/include/alglib";
    ALGLIB_LIBRARIES = "alglib3";
    ROUTINO_XML_PATH = "${routino}/share/routino";
  };

  qtWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        gdal
        routino
      ]
    }"
  ];

  meta = {
    description = "Consumer grade GIS software";
    homepage = "https://github.com/Maproom/qmapshack";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
