{
  cmake,
  fetchFromGitHub,
  lib,
  libkrb5,
  openssl,
  postgresql,
  postgresqlBuildExtension,

  enableUnfree ? true,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "timescaledb${lib.optionalString (!enableUnfree) "-apache"}";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb";
    tag = finalAttrs.version;
    hash = "sha256-m5aBxOOH04b0iDvApvY30uvYsFoV+WEBnKP4Ssr0t/M=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = [
    openssl
    libkrb5
  ];

  cmakeEntries = {
    SEND_TELEMETRY_DEFAULT = false;
    REGRESS_CHECKS = false;
    TAP_CHECKS = false;
    APACHE_ONLY = !enableUnfree;
  };

  # Fix the install phase which tries to install into the pgsql extension dir,
  # and cannot be manually overridden.
  postPatch = ''
    for x in CMakeLists.txt sql/CMakeLists.txt; do
      substituteInPlace "$x" \
        --replace-fail 'DESTINATION "''${PG_SHAREDIR}/extension"' "DESTINATION \"$out/share/postgresql/extension\""
    done

    for x in src/CMakeLists.txt src/loader/CMakeLists.txt tsl/src/CMakeLists.txt; do
      substituteInPlace "$x" \
        --replace-fail 'DESTINATION ''${PG_PKGLIBDIR}' "DESTINATION \"$out/lib\""
    done
  '';

  meta = {
    description = "Time-series database extension for PostgreSQL";
    homepage = "https://www.timescale.com/";
    changelog = "https://github.com/timescale/timescaledb/releases/tag/${finalAttrs.version}";
    license = if enableUnfree then lib.licenses.tsl else lib.licenses.asl20;
    platforms = postgresql.meta.platforms;
    broken =
      postgresql != null && lib.versionAtLeast postgresql.version "18" && finalAttrs.version == "2.25.0";
  };
})
