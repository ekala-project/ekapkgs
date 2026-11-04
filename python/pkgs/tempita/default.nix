{
  lib,
  buildPythonPackage,
  fetchurl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tempita";
  version = "0.6.0";
  pyproject = true;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/74/d5/ad8a832e120cb9b743f175b80368b457a1078cd65bd9b8578aca5ddb1bd2/tempita-${version}.tar.gz";
    hash = "sha256-duFd4BN+UBHCKUnMFaUWH2I/5qMWVXUcbXZdtrusJ7Y=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "tempita" ];

  meta = {
    description = "Small templating language for text substitution";
    homepage = "https://pypi.org/project/Tempita/";
    license = lib.licenses.mit;
  };
}
