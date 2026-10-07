{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "nomad";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    rev = "v${version}";
    hash = "sha256-JOcN8Xyey84R2oA1lr9f6k/aNY1AJreig3fP3IM9C1M=";
  };

  vendorHash = "sha256-5/ziFzfTgjtvRWCEZoRQMA+1BeAwJwWV9R5C4jSFuPA=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X github.com/hashicorp/nomad/version.Version=${version}"
    "-X github.com/hashicorp/nomad/version.VersionPrerelease="
    "-X github.com/hashicorp/nomad/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  tags = [ "ui" ];

  doCheck = false;

  postInstall = ''
    echo "complete -C $out/bin/nomad nomad" > nomad.bash
    installShellCompletion nomad.bash
  '';

  meta = {
    homepage = "https://developer.hashicorp.com/nomad";
    description = "Distributed, Highly Available, Datacenter-Aware Scheduler";
    mainProgram = "nomad";
    license = lib.licenses.bsl11;
  };
}
