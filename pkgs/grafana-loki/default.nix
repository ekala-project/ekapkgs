{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  version = "3.7.8";
  pname = "grafana-loki";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H+4qSXf0gZL2RCf5o4v4V3/ozLVESdhy0QDEpXbAGuc=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/loki"
    "cmd/loki-canary"
    "cmd/logcli"
    "cmd/lokitool"
  ];

  ldflags =
    let
      t = "github.com/grafana/loki/v3/pkg/util/build";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.Revision=unknown"
    ];

  meta = {
    description = "Like Prometheus, but for logs";
    mainProgram = "loki";
    license = with lib.licenses; [
      agpl3Only
      asl20
    ];
    homepage = "https://grafana.com/oss/loki/";
    changelog = "https://github.com/grafana/loki/releases/tag/v${finalAttrs.version}";
  };
})
