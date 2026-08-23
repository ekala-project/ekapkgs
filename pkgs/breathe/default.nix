{
  lib,
  python3,
  fetchFromGitHub,
  sphinx,
}:

python3.pkgs.buildPythonPackage {
  pname = "breathe";
  version = "4.35.0-unstable-2025-01-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breathe-doc";
    repo = "breathe";
    rev = "9711e826e0c46a635715e5814a83cab9dda79b7b";
    hash = "sha256-Ie+8RLWeBgbC4s3TC6ege2YNdfdM0d906BPxB7EOwq8=";
  };

  build-system = [ python3.pkgs.flit-core ];

  dependencies = [ sphinx ];

  doCheck = false;

  pythonImportsCheck = [ "breathe" ];

  meta = {
    description = "Sphinx Doxygen renderer";
    mainProgram = "breathe-apidoc";
    homepage = "https://github.com/breathe-doc/breathe";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
