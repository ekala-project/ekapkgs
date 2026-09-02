{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "csvkit";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FHMYqNuuwHwLu5KRwUt43l+jLtPUpcI5blKoPAow32s=";
  };

  pythonRemoveDeps = [ "agate-dbf" ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    agate
    agate-excel
    agate-sql
    setuptools
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/wireservice/csvkit";
    description = "Suite of command-line tools for converting to and working with CSV";
    license = lib.licenses.mit;
  };
})
