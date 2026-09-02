{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "nomad";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    rev = "v${version}";
    hash = "sha256-J+w53HlMlrXX5yKjDYhf3rSGt1pmOyNcPlOqyUrkLWE=";
  };

  vendorHash = "sha256-67etQUjcPXz4VVpNXLVusQlEybxEqKfYQcNTNL4X8bA=";

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
