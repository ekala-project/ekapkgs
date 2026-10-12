{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgjwt";
  version = "0-unstable-2023-03-02";

  src = fetchFromGitHub {
    owner = "michelp";
    repo = "pgjwt";
    rev = "f3d82fd30151e754e19ce5d6a06c71c20689ce3d";
    hash = "sha256-nDZEDf5+sFc1HDcG2eBNQj+kGcdAYRXJseKi9oww+JU=";
  };

  meta = {
    description = "PostgreSQL implementation of JSON Web Tokens";
    longDescription = ''
      sign() and verify() functions to create and verify JSON Web Tokens.
    '';
    homepage = "https://github.com/michelp/pgjwt";
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
