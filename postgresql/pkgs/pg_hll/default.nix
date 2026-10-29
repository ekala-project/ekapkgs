{
  fetchFromGitHub,
  fetchpatch,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_hll";
  version = "2.18";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "postgresql-hll";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Latdxph1Ura8yKEokEjalJ+/GY+pAKOT3GXjuLprj6c=";
  };

  patches = [
    (fetchpatch {
      name = "fix-postgresql-18.patch";
      url = "https://github.com/citusdata/postgresql-hll/commit/f998e234653ea397ddddc1278d1c02d8d011bd16.patch";
      hash = "sha256-gF4f+B4Gu/QEyCGMfKLmRK6lNwgfd8lML55wMkhsSY4=";
    })
  ];

  meta = {
    description = "HyperLogLog data structure as a PostgreSQL extension";
    homepage = "https://github.com/citusdata/postgresql-hll";
    license = lib.licenses.asl20;
    platforms = postgresql.meta.platforms;
  };
})
