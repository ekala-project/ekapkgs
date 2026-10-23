{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_relusage";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "adept";
    repo = "pg_relusage";
    tag = finalAttrs.version;
    hash = "sha256-8hJNjQ9MaBk3J9a73l+yQMwMW/F2N8vr5PO2o+5GvYs=";
  };

  meta = {
    description = "Discover and log the relations used in your statements";
    homepage = "https://github.com/adept/pg_relusage";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
  };
})
