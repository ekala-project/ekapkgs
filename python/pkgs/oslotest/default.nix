{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  fixtures,
  six,
}:

buildPythonPackage rec {
  pname = "oslotest";
  version = "6.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XOlzR3NPCMpia7SWliqLx6266Wk3MPWFnZxSk9Si/YA=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    fixtures
    six
  ];

  # Tests lead to infinite recursion with other oslo components
  doCheck = false;

  pythonImportsCheck = [ "oslotest" ];

  meta = {
    description = "Oslo test framework";
    homepage = "https://github.com/openstack/oslotest";
    license = lib.licenses.asl20;
  };
}
