{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "consul";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul";
    tag = "v${version}";
    hash = "sha256-vjGlxmruHuIfBjmw/KHOm6xoKMAsZ+fVpfx+93nFJc8=";
  };

  subPackages = [
    "."
    "connect/certgen"
  ];

  vendorHash = "sha256-rUYjQqEoZ4RzhJIGYot7LXbwLFmfWEie8F7F6Oczh4Q=";

  doCheck = false;

  ldflags = [
    "-X github.com/hashicorp/consul/version.GitDescribe=v${version}"
    "-X github.com/hashicorp/consul/version.Version=${version}"
    "-X github.com/hashicorp/consul/version.VersionPrerelease="
  ];

  meta = {
    description = "Tool for service discovery, monitoring and configuration";
    homepage = "https://www.consul.io/";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsl11;
    mainProgram = "consul";
  };
}
