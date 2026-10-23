{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:
postgresqlBuildExtension (finalAttrs: {
  pname = "system_stats";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "system_stats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/xXnui0S0ZjRw7P8kMAgttHVv8T41aOhM3pM8P0OTig=";
  };

  meta = {
    description = "PostgreSQL extension to access system-level statistics";
    homepage = "https://github.com/EnterpriseDB/system_stats";
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
