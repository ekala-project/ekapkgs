{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  expat,
  proj,
  bzip2,
  zlib,
  boost,
  libpq,
  lua,
  libosmium,
  nlohmann_json,
  opencv,
  potrace,
  protozero,
  fmt,
  cli11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm2pgsql";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "osm2pgsql-dev";
    repo = "osm2pgsql";
    rev = finalAttrs.version;
    hash = "sha256-tvcnXsbHjke/25PKfWMANHI9K3CModTW8uxI2JxCWi4=";
  };

  postPatch = ''
    rm -r contrib
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    bzip2
    cli11
    expat
    fmt
    libosmium
    libpq
    lua.v5_5
    nlohmann_json
    opencv
    potrace
    proj
    protozero
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "EXTERNAL_LIBOSMIUM" true)
    (lib.cmakeBool "EXTERNAL_PROTOZERO" true)
    (lib.cmakeBool "EXTERNAL_FMT" true)
    (lib.cmakeBool "WITH_LUAJIT" false)
  ];

  meta = {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://osm2pgsql.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
