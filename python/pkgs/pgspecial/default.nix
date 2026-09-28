{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  sqlparse,
  psycopg,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "2.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2mx/zHvve7ATLcIEb3TsZROx/m8MgOVSjWMNFLfEhJ0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    sqlparse
    psycopg
  ];

  # Tests require postgresqlTestHook which is not available
  doCheck = false;

  pythonImportsCheck = [ "pgspecial" ];

  meta = {
    description = "Meta-commands handler for Postgres Database";
    homepage = "https://github.com/dbcli/pgspecial";
    changelog = "https://github.com/dbcli/pgspecial/releases/tag/v${version}";
    license = lib.licenses.bsd3;
  };
}
