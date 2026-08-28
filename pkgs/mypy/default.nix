{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mypy";
  version = "1.20.1";
  pyproject = true;

  disabled = python3Packages.isPyPy;

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    tag = "v${version}";
    hash = "sha256-MQZZyGu6xFh3wO+0lWED+mingjK92v/onljtp9gylmM=";
  };

  build-system = with python3Packages; [
    mypy-extensions
    pathspec
    setuptools
    types-psutil
    types-setuptools
    typing-extensions
  ];

  dependencies = with python3Packages; [
    librt
    mypy-extensions
    pathspec
    typing-extensions
  ];

  optional-dependencies = with python3Packages; {
    dmypy = [ psutil ];
    reports = [ lxml ];
  };

  # Compile mypy with mypyc, which makes mypy about 4 times faster.
  # Disabled due to pathspec version incompatibility during self-check.
  env.MYPY_USE_MYPYC = false;

  # when testing reduce optimisation level to reduce build time by 20%
  env.MYPYC_OPT_LEVEL = 1;

  doCheck = false;

  pythonImportsCheck = [
    "mypy"
    "mypy.api"
    "mypy.fastparse"
    "mypy.types"
    "mypyc"
    "mypyc.analysis"
  ];

  meta = {
    description = "Optional static typing for Python";
    homepage = "https://www.mypy-lang.org";
    downloadPage = "https://github.com/python/mypy";
    license = lib.licenses.mit;
    mainProgram = "mypy";
  };
}
