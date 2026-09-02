{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  procps,
}:

python3Packages.buildPythonPackage rec {
  pname = "yubikey-manager";
  version = "5.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubikey-manager";
    tag = version;
    hash = "sha256-9ngsjXkQ3YUc5nCgG1i592LoVERr4jRSKi8POBaP/aw=";
  };

  postPatch = ''
    substituteInPlace "ykman/pcsc/__init__.py" \
      --replace-fail 'pkill' '${procps}/bin/pkill'
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    click
    cryptography
    fido2
  ];

  pythonRelaxDeps = [
    "cryptography"
  ];

  pythonRemoveDeps = [
    "keyring"
    "pyscard"
    "python-pskc"
  ];

  postInstall = ''
    installManPage man/ykman.1
  '';

  meta = {
    homepage = "https://developers.yubico.com/yubikey-manager";
    changelog = "https://github.com/Yubico/yubikey-manager/releases/tag/${src.tag}";
    description = "Command line tool for configuring any YubiKey over all USB transports";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    mainProgram = "ykman";
  };
}
