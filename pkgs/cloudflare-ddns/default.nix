{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module (finalAttrs: {
  pname = "cloudflare-ddns";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "favonia";
    repo = "cloudflare-ddns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-03aXACmEXX75CGvnf1vuXhsMEcLb1W8/LL6GrdPORWE=";
  };

  vendorHash = "sha256-/vo5msKJ9J6Ga7BqGwavLlUGUSvkaCtmYFDI/2zBCv4=";

  subPackages = [
    "cmd/ddns"
  ];

  meta = {
    description = "Dynamic DNS (DDNS) client for Cloudflare";
    longDescription = ''
      A feature-rich and robust Cloudflare DDNS updater with a small footprint.
      The program will detect your machine’s public IP addresses and update DNS records using the Cloudflare API.
    '';
    homepage = "https://github.com/favonia/cloudflare-ddns";
    mainProgram = "ddns";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.darwin;
  };
})
