{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_topn";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "postgresql-topn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lP6Iil/BUv4ga+co+oBpKv1FBqFuBGfNjueEolM6png=";
  };

  meta = {
    description = "Efficient querying of 'top values' for PostgreSQL";
    homepage = "https://github.com/citusdata/postgresql-topn";
    changelog = "https://github.com/citusdata/postgresql-topn/raw/v${finalAttrs.version}/CHANGELOG.md";
    platforms = postgresql.meta.platforms;
    license = lib.licenses.agpl3Only;
  };
})
