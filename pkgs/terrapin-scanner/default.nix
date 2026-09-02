{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "terrapin-scanner";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "RUB-NDS";
    repo = "Terrapin-Scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PmKfHvad+YAwLcdoiDSOBMQFgOKzJ6NbGbt4v570gyI=";
  };

  vendorHash = "sha256-x3fzs/TNGRo+u+RufXzzjDCeQayEZIKlgokdEQJRNaI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Vulnerability scanner for the Terrapin attack";
    homepage = "https://github.com/RUB-NDS/Terrapin-Scanner";
    license = lib.licenses.asl20;
    mainProgram = "Terrapin-Scanner";
  };
})
