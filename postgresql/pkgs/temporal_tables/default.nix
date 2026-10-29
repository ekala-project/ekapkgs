{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "temporal_tables";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "arkhipov";
    repo = "temporal_tables";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+DCSPAPhsokWDq/5IXNhd7jY6FfzxxUjlsg/VJeD3k=";
  };

  meta = {
    description = "Temporal (system-period) tables for PostgreSQL";
    homepage = "https://github.com/arkhipov/temporal_tables";
    license = lib.licenses.bsd2;
    platforms = postgresql.meta.platforms;
  };
})
