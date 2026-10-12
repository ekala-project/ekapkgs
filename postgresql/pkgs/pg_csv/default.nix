{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_csv";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "PostgREST";
    repo = "pg_csv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hRTNFlNUmc3mjDf0wgn4CGmHoYPQ+2yfZApzooLwgW4=";
  };

  meta = {
    description = "Flexible CSV aggregates for PostgreSQL";
    homepage = "https://github.com/PostgREST/pg_csv";
    license = lib.licenses.mit;
    platforms = postgresql.meta.platforms;
  };
})
