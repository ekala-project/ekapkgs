{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pre-commit";
  version = "4.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "pre-commit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aCEN9dVz/3lB2gy7U+6dVj3jSM7cmVsstOp+LHvYRsU=";
  };

  patches = [
    ./languages-use-the-hardcoded-path-to-python-binaries.patch
    ./hook-tmpl.patch
    ./pygrep-pythonpath.patch
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    cfgv
    identify
    nodeenv
    pyyaml
    toml
    virtualenv
  ];

  postPatch = ''
    substituteInPlace pre_commit/resources/hook-tmpl \
      --subst-var-by pre-commit $out
    substituteInPlace pre_commit/languages/python.py \
      --subst-var-by virtualenv ${python3Packages.virtualenv}
    substituteInPlace pre_commit/languages/node.py \
      --subst-var-by nodeenv ${python3Packages.nodeenv}

    patchShebangs pre_commit/resources/hook-tmpl
  '';

  doCheck = false;

  pythonImportsCheck = [
    "pre_commit"
  ];

  # add gitMinimal as fallback, if git is not installed
  preFixup = ''
    makeWrapperArgs+=(--suffix PATH : ${lib.makeBinPath [ gitMinimal ]})
  '';

  meta = {
    description = "Framework for managing and maintaining multi-language pre-commit hooks";
    homepage = "https://pre-commit.com/";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pre-commit";
  };
})
