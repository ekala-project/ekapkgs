{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "cookiecutter";
  version = "2.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Kc4/0V0bqWBvZ+78J3R/VRXv/1e19N6HQzl5csCHso=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    binaryornot
    jinja2
    click
    pyyaml
    jinja2-time
    python-slugify
    requests
    arrow
    rich
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/audreyr/cookiecutter";
    description = "Command-line utility that creates projects from project templates";
    mainProgram = "cookiecutter";
    license = lib.licenses.bsd3;
  };
}
