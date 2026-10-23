{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_roaringbitmap";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ChenHuajun";
    repo = "pg_roaringbitmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XX68Kgx9uFhnWSUIhErw3yOjo7K/seP/6oca3vS7b84=";
  };

  meta = {
    description = "Roaring bitmap type and functions for PostgreSQL";
    homepage = "https://github.com/ChenHuajun/pg_roaringbitmap";
    license = lib.licenses.asl20;
    platforms = postgresql.meta.platforms;
  };
})
