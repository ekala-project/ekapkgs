{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wappalyzergo";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "wappalyzergo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pg1m9mcx/BpUh3HQhO5ZjneTVPGFEhN3Qpqz5HA82PI=";
  };

  vendorHash = "sha256-gL98jxXRPMmyx6LrI2Z4pNMRAh4iEDBXg4I1661enR4=";

  ldflags = [ "-s" ];

  meta = {
    description = "Implementation of the Wappalyzer Technology Detection Library";
    homepage = "https://github.com/projectdiscovery/wappalyzergo";
    changelog = "https://github.com/projectdiscovery/wappalyzergo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "wappalyzergo";
  };
})
