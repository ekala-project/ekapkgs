{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  git,
  openssh,
  gnupg,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "git-revise";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mystor";
    repo = "git-revise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OdkhYEq30RtDOeCQWl/L9FMgCttznzihbYgT8B6KYuY=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeCheckInputs = [
    git
    openssh
    python3Packages.pytestCheckHook
    gnupg
  ];

  meta = {
    description = "Efficiently update, split, and rearrange git commits";
    homepage = "https://github.com/mystor/git-revise";
    changelog = "https://github.com/mystor/git-revise/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "git-revise";
  };
})
