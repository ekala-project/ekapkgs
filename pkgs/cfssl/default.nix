{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cfssl";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfssl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-te5qgl+mJnrPMpXbwJY/GG0zNKaHWmwJpNBCQtjhAck=";
  };

  subPackages = [
    "cmd/cfssl"
    "cmd/cfssljson"
    "cmd/cfssl-bundle"
    "cmd/cfssl-certinfo"
    "cmd/cfssl-newkey"
    "cmd/cfssl-scan"
    "cmd/multirootca"
    "cmd/mkbundle"
  ];

  vendorHash = null;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudflare/cfssl/cli/version.version=v${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://cfssl.org/";
    description = "Cloudflare's PKI and TLS toolkit";
    license = lib.licenses.bsd2;
    mainProgram = "cfssl";
  };
})
