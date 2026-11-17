{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "nextdns";
  version = "1.50.1";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-CCkdTSdxsE3hluuR0LuuLRB6pSI8wLKg47GDoddtSq0=";
  };

  vendorHash = "sha256-3Evnbwg3Q2SrmJUrPIEirMeHYnySofS4EEGvd7x6H7E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = lib.licenses.mit;
    mainProgram = "nextdns";
  };
})
