{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorama,
  scipy,
  numpy,
  pyopengl,
  pyqt5,
}:

buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyqtgraph";
    repo = "pyqtgraph";
    tag = "pyqtgraph-${version}";
    hash = "sha256-T5rhaBtcKP/sYjCmYNMYR0BGttkiLhWTfEbZNeAdJJ0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    numpy
    scipy
    pyopengl
  ];

  buildInputs = [ pyqt5 ];

  doCheck = false;

  pythonImportsCheck = [ "pyqtgraph" ];

  meta = {
    description = "Scientific Graphics and GUI Library for Python";
    homepage = "https://www.pyqtgraph.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
