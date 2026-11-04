{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  text-unidecode,
}:

buildPythonPackage rec {
  pname = "python-slugify";
  version = "8.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "python-slugify";
    tag = "v${version}";
    hash = "sha256-zReUMIkItnDot3XyYCoPUNHrrAllbClWFYcxdTy3A30=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ text-unidecode ];

  # Tests require pytestCheckHook

  pythonImportsCheck = [ "slugify" ];

  meta = {
    description = "Python Slugify application that handles Unicode";
    mainProgram = "slugify";
    homepage = "https://github.com/un33k/python-slugify";
    license = lib.licenses.mit;
  };
}
