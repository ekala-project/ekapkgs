{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "liquidctl";
  version = "1.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liquidctl";
    repo = "liquidctl";
    tag = "v${version}";
    hash = "sha256-NN/LPcRwj1c9xIIBmNCSLkb+8LHPIqH/YuLPm3kxqEQ=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    docopt
    pyusb
    colorlog
    crcmod
  ];

  doCheck = false;

  # Disable runtime dependency check — some optional deps (hidapi, pillow, smbus)
  # are not yet available in the python package set
  pythonRuntimeDepsCheck = false;
  dontCheckRuntimeDeps = true;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp extra/linux/71-liquidctl.rules $out/lib/udev/rules.d/.
  '';

  meta = {
    description = "Cross-platform CLI and Python drivers for AIO liquid coolers and other devices";
    homepage = "https://github.com/liquidctl/liquidctl";
    license = lib.licenses.gpl3Plus;
    mainProgram = "liquidctl";
    platforms = lib.platforms.linux;
  };
}
