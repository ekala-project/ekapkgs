{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_squeeze";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "cybertec-postgresql";
    repo = "pg_squeeze";
    tag = "REL${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-KbCS3kg2MoxKHl+35UOFCSF4kPPsIMeO7AfwfHZYZVg=";
  };

  meta = {
    description = "Remove bloat from a PostgreSQL table without blocking reads/writes";
    homepage = "https://github.com/cybertec-postgresql/pg_squeeze";
    license = lib.licenses.bsd3;
    platforms = postgresql.meta.platforms;
  };
})
