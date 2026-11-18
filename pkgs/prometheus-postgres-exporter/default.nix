{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    tag = "v${version}";
    sha256 = "sha256-gX/8KEROLVLe3t3uewsUg5Rz/iExWPiqSVcwfYVaF2Y=";
  };

  vendorHash = "sha256-C/Jk6ZxLGpUI4Kyc0mwokSksNYMqj4zhZkGyzNwJFic=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  doCheck = true;

  meta = {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for PostgreSQL";
    mainProgram = "postgres_exporter";
    license = lib.licenses.asl20;
  };
}
