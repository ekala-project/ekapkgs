{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sqlite,
  libtiff,
  curl,
  nlohmann_json,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proj";
  version = "9.8.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    tag = finalAttrs.version;
    hash = "sha256-sOAxWihgU1TAMWcju5LN4cPenHHoGgd4oYJ4HA3F/Ks=";
  };

  patches = [
    ./only-add-curl-for-static-builds.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    sqlite
    libtiff
    curl
    nlohmann_json
  ];

  cmakeFlags = [
    "-DNLOHMANN_JSON_ORIGIN=external"
    "-DEXE_SQLITE3=${sqlite}/bin/sqlite3"
    "-DBUILD_TESTING=OFF"
  ];

  env.CXXFLAGS = toString [
    "-include"
    "cstdint"
  ];

  doCheck = false;

  meta = {
    description = "Cartographic Projections Library";
    homepage = "https://proj.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
