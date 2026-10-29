{
  fetchFromGitHub,
  lib,
  libversion,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_libversion";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "postgresql-libversion";
    tag = finalAttrs.version;
    hash = "sha256-3nqXaBwPRUSo6wUY5YMjJ/nFFKmhgP1zFKapD+RqSDw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libversion ];

  meta = {
    description = "PostgreSQL extension with support for version string comparison";
    homepage = "https://github.com/repology/postgresql-libversion";
    license = lib.licenses.mit;
    platforms = postgresql.meta.platforms;
  };
})
