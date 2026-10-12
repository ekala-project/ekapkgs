{
  cmake,
  fetchFromGitHub,
  h3,
  lib,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "h3-pg";
  version = "4.2.3";

  src = fetchFromGitHub {
    # The upstream moved from zachasme/h3-pg to postgis/h3-pg.
    owner = "postgis";
    repo = "h3-pg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kTh0Y0C2pNB5Ul1rp77ets/5VeU1zw1WasGHkOaDMh8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(cmake/h3)" "include_directories(${lib.getDev h3}/include/h3)"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/AddPostgreSQLExtension.cmake \
      --replace-fail "INTERPROCEDURAL_OPTIMIZATION TRUE" ""
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ h3 ];

  meta = {
    description = "PostgreSQL bindings for H3, a hierarchical hexagonal geospatial indexing system";
    homepage = "https://github.com/postgis/h3-pg";
    license = lib.licenses.asl20;
    platforms = postgresql.meta.platforms;
  };
})
