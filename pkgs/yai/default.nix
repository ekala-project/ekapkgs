{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "yai";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ekkinox";
    repo = "yai";
    rev = finalAttrs.version;
    sha256 = "sha256-MoblXLfptlIYJbXQTpbc8GBo2a3Zgxdvwra8IUEGiZs==";
  };

  vendorHash = "sha256-+NhYK8FXd5B3GsGUPJOMM7Tt3GS1ZJ7LeApz38Xkwx8=";

  ldflags = [
    "-w"
    "-s"
    "-X main.buildVersion=${finalAttrs.version}"
  ];

  preCheck = ''
    export USER=test
  '';

  meta = {
    homepage = "https://github.com/ekkinox/yai";
    description = "Your AI powered terminal assistant";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "yai";
  };
})
