{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "rum";
  version = "1.3.15";

  src = fetchFromGitHub {
    owner = "postgrespro";
    repo = "rum";
    tag = finalAttrs.version;
    hash = "sha256-iOx7u0JURBUUFerRlg3DuidFeBmGFOXz8mu20mQeopo=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "Full text search index method for PostgreSQL";
    homepage = "https://github.com/postgrespro/rum";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
  };
})
