{
  lib,
  python3Packages,
  fetchFromGitHub,
  stress,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "s-tui";
  version = "1.4.0";
  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  src = fetchFromGitHub {
    owner = "amanusk";
    repo = "s-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PDDT37W0x7VJ6OnkbwvPXttphD+vHDul0zmA3VY/Sao=";
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
    maintainers = [ ];
    mainProgram = "s-tui";
  };
})
