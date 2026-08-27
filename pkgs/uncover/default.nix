{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "uncover";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "uncover";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LFKCUBBgG7dTQhJF9iciyU7GTnQsO+ZdVCtaOnl+Et0=";
  };

  vendorHash = "sha256-Pkpp2D3b3A5TQ8eXaOf6qKUY/bamdytmuqOVAozK9k0=";

  subPackages = [ "cmd/uncover" ];

  ldflags = [ "-s" ];

  doCheck = false;

  meta = {
    description = "API wrapper to search for exposed hosts";
    homepage = "https://github.com/projectdiscovery/uncover";
    changelog = "https://github.com/projectdiscovery/uncover/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "uncover";
  };
})
