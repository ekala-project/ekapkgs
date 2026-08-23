{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "esptool";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oHQ6rkMnzvjtP/dg+tyc7Dw+D/WuWDqRwqePKBBnjCw=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    bitstring
    click
    cryptography
    intelhex
    pyserial
    pyyaml
    reedsolo
    rich-click
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    rm -v $out/bin/*.py

    installShellCompletion --cmd esptool \
      --bash <(_ESPTOOL_COMPLETE=bash_source $out/bin/esptool) \
      --zsh <(_ESPTOOL_COMPLETE=zsh_source $out/bin/esptool) \
      --fish <(_ESPTOOL_COMPLETE=fish_source $out/bin/esptool)
  '';

  doCheck = false;

  meta = {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "esptool";
  };
})
