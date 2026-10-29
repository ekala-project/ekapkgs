{
  curl,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_net";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_net";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8xhk3WPONVjB2JIIRDBJP9fmtlMx0ld2t9GFYIzTYyQ=";
  };

  buildInputs = [ curl ];

  meta = {
    description = "Async HTTP client for PostgreSQL";
    homepage = "https://github.com/supabase/pg_net";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
  };
})
