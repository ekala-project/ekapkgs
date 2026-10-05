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
  version = "9.9.0";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    tag = finalAttrs.version;
    hash = "sha256-3WJCqH+8MCs/UOmnCqIehLEnkoLCBRCReO05UP2A02A=";
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
