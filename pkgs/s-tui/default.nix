{
  lib,
  python3Packages,
  fetchFromGitHub,
  stress,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "s-tui";
  version = "1.5.0";
  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  src = fetchFromGitHub {
    owner = "amanusk";
    repo = "s-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mxYnmGPW6kPmhROda2k7L9oGt05tPdIPeX6JYeDjKJs=";
  };

  dependencies = [
    python3Packages.urwid
    python3Packages.psutil
    stress
  ];

  meta = {
    homepage = "https://amanusk.github.io/s-tui/";
    description = "Stress-Terminal UI monitoring tool";
    license = lib.licenses.gpl2Plus;
    mainProgram = "s-tui";
  };
})
