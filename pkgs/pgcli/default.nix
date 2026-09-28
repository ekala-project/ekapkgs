{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "pgcli";
  version = "4.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nc4H9bYoBoFWJWy4GOUZGnc6/m7rcFTyEPqJKBNiXj4=";
  };

  pythonRelaxDeps = [
    "click"
    "sqlparse"
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    cli-helpers
    click
    configobj
    prompt-toolkit
    psycopg
    pygments
    sqlparse
    pgspecial
    setproctitle
    keyring
    pendulum
    sshtunnel
    tzlocal
  ];

  # Tests require a running PostgreSQL instance
  doCheck = false;

  pythonImportsCheck = [ "pgcli" ];

  meta = {
    description = "Command-line interface for PostgreSQL";
    mainProgram = "pgcli";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "https://pgcli.com";
    changelog = "https://github.com/dbcli/pgcli/raw/v${version}/changelog.rst";
    license = lib.licenses.bsd3;
  };
}
