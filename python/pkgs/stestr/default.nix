{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  cliff,
  fixtures,
  python-subunit,
  testtools,
  tomlkit,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "stestr";
  version = "4.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rexjny0cw3LjYwYTuT83zynT3+adSdTz+UCNN7Ebwpw=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    cliff
    fixtures
    python-subunit
    testtools
    tomlkit
    voluptuous
  ];

  # check in passthru.tests to escape infinite recursion with other oslo components
  doCheck = false;

  pythonImportsCheck = [ "stestr" ];

  meta = {
    description = "Parallel Python test runner built around subunit";
    mainProgram = "stestr";
    homepage = "https://github.com/mtreinish/stestr";
    license = lib.licenses.asl20;
  };
}
