{
  lib,
  python3,
  fetchFromGitHub,
  git,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hermes-hud";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joeynyc";
    repo = "hermes-hud";
    tag = "v${version}";
    hash = "sha256-Osn/+7qnRQORBJLWgngLT2BU0EVu2xyRN7De619IDNI=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    pyyaml
    textual
    # upstream "neofetch" extra, needed for --neofetch/--br/--fsociety modes
    pyfiglet
  ];

  pythonImportsCheck = [ "hermes_hud" ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    # tests create git repos to exercise the projects collector
    git
  ];

  meta = {
    description = "TUI consciousness monitor for Hermes Agent";
    homepage = "https://github.com/joeynyc/hermes-hud";
    changelog = "https://github.com/joeynyc/hermes-hud/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "hermes-hud";
  };
}
