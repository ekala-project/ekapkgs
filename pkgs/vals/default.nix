{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "vals";
  version = "0.46.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "helmfile";
    repo = "vals";
    sha256 = "sha256-aDFCJaAhZNxo/E++/yFeqeTttvmT4FHhcFzSV6Mn2ck=";
  };

  vendorHash = "sha256-eVoKsXFtvfGU3XUH+U9PKPYGCDNyGGrj8F0EANonkuY=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # Tests require connectivity to various backends.
  doCheck = false;

  meta = {
    description = "Helm-like configuration values loader with support for various sources";
    mainProgram = "vals";
    license = lib.licenses.asl20;
    homepage = "https://github.com/helmfile/vals";
    changelog = "https://github.com/helmfile/vals/releases/v${finalAttrs.version}";
    maintainers = [ ];
  };
})
