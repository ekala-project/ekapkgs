{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "node_exporter";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "node_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-duuWzokkQ38sPj5I7MTFKaWKP/YZAkyhC0EIn5O41Es=";
  };

  vendorHash = "sha256-6NhxA/aQJT8t19+Pb21HL0TOTxU729bqGpmq3IO8IVQ=";

  # FIXME: tests fail due to read-only nix store

  excludedPackages = [ "docs/node-mixin" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Revision=unknown"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  nativeInstallCheckInputs = [
  ];

  doInstallCheck = true;

  meta = {
    description = "Prometheus exporter for machine metrics";
    mainProgram = "node_exporter";
    homepage = "https://github.com/prometheus/node_exporter";
    changelog = "https://github.com/prometheus/node_exporter/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
})
