{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "cloudflare-ddns";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "favonia";
    repo = "cloudflare-ddns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lXWGVhthBEPRAYhrpjGfskRxmPeKwwjqbqW/wRMLDF8=";
  };

  vendorHash = "sha256-vq8iavsJFk3Eu1mwyeJLtWSXV8pbeqMnbO/UL/8Af4A=";

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
