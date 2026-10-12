{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "plpgsql-check";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "plpgsql_check";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1EMK6WTJ/LBB0oD4i+Lni8wMh80HZtop8uRqwm3XwKw=";
  };

  meta = {
    description = "Extended checks for PL/pgSQL functions";
    homepage = "https://github.com/okbob/plpgsql_check";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
  };
})
