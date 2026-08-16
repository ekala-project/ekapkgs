{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "codespell";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codespell-project";
    repo = "codespell";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-oWVhD9KINWNW75ufPK3yKJJ3zV2AaR6LNok4RQK1PLA=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  doCheck = false;

  pythonImportsCheck = [ "codespell_lib" ];

  meta = {
    description = "Fix common misspellings in source code";
    mainProgram = "codespell";
    homepage = "https://github.com/codespell-project/codespell";
    license = with lib.licenses; [
      gpl2Only
      cc-by-sa-30
    ];
    maintainers = [ ];
  };
})
