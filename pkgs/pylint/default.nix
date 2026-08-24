{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pylint";
  version = "4.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylint-dev";
    repo = "pylint";
    rev = "5f7e4013c004324f11eac6f310d932f505272e28";
    hash = "sha256-fdOA/ofrEMfzlbVbN6f5LE9nGC7QlggBU/SKW70iaC8=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    astroid
    dill
    isort
    mccabe
    platformdirs
    tomlkit
  ];

  doCheck = false;

  pythonRelaxDeps = [ "astroid" ];

  meta = {
    description = "Bug and style checker for Python";
    homepage = "https://pylint.readthedocs.io/en/stable/";
    longDescription = ''
      Pylint is a Python static code analysis tool which looks for programming errors,
      helps enforcing a coding standard, sniffs for code smells and offers simple
      refactoring suggestions.
      Pylint is shipped with following additional commands:
      - pyreverse: an UML diagram generator
      - symilar: an independent similarities checker
      - epylint: Emacs and Flymake compatible Pylint
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "pylint";
  };
})
