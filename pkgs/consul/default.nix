{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "consul";
  version = "1.22.7";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul";
    tag = "v${version}";
    hash = "sha256-lcb2Dbr5rpNbtstEk7kQxEYHdN3/FQEHFH+NIa6czDU=";
  };

  subPackages = [
    "."
    "connect/certgen"
  ];

  vendorHash = "sha256-tFa8UKeaAQR4q+WpRl/u5P+TpjdBh9Gf6bVQcwzP5QQ=";

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
