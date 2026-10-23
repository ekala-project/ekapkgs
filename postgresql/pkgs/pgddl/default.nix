{
  fetchFromGitHub,
  lib,
  perl,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgddl";
  version = "0.30";

  src = fetchFromGitHub {
    owner = "lacanoid";
    repo = "pgddl";
    tag = finalAttrs.version;
    hash = "sha256-w08IgnobIhlwRGrz+feEnZbI1KrWrMRI4BvNVUZFSSg=";
  };

  nativeBuildInputs = [ perl ];

  preBuild = ''
    patchShebangs --build ./bin/ ./docs
  '';

  meta = {
    description = "DDL eXtractor functions for PostgreSQL";
    homepage = "https://github.com/lacanoid/pgddl";
    changelog = "https://github.com/lacanoid/pgddl/releases/tag/${finalAttrs.version}";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
  };
})
