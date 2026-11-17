{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    tag = "v${version}";
    sha256 = "sha256-04w7hr0p0Zh9IiuqYEELIWbRNu9j2HrybjQPVI37uKg=";
  };

  vendorHash = "sha256-PGcnhJkFf0+jyjsJ4ebxR2hM1LGcNzyAWOsqWuPudTU=";

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
