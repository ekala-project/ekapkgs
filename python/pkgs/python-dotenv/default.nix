{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theskumar";
    repo = "python-dotenv";
    tag = "v${version}";
    hash = "sha256-MoBt3QsY5u3r852MtVWZS9tFXpyK8aRZlLG3rpzIVrY=";
  };

  build-system = [ setuptools ];

  optional-dependencies.cli = [ click ];

  pythonImportsCheck = [ "dotenv" ];

  # Tests require additional dependencies

  meta = {
    description = "Add .env support to your django/flask apps in development and deployments";
    mainProgram = "dotenv";
    homepage = "https://github.com/theskumar/python-dotenv";
    license = lib.licenses.bsdOriginal;
  };
}
