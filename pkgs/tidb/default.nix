{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
}:

# TiDB's `pkg/util/hack` package aborts unless the toolchain's minor version
# matches exactly (go1.25); the default ekapkgs go (1.27) panics at startup.
buildGoModule.override { go = go.v1_25; } rec {
  pname = "tidb";
  version = "8.5.5";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "tidb";
    rev = "v${version}";
    sha256 = "sha256-wrCdclS9qpc0mq5QZ6u5/APZyOTWvCJNCPCzM385MBM=";
  };

  vendorHash = "sha256-7g8U0gbG46AC4h1SyOTKKuNc5eVRqJsimzshj4O5FYw=";

  ldflags = [
    "-X github.com/pingcap/tidb/pkg/parser/mysql.TiDBReleaseVersion=${version}"
    "-X github.com/pingcap/tidb/pkg/util/versioninfo.TiDBEdition=Community"
  ];

  subPackages = [ "cmd/tidb-server" ];

  meta = {
    description = "Open-source, cloud-native, distributed, MySQL-Compatible database for elastic scale and real-time analytics";
    homepage = "https://pingcap.com";
    license = lib.licenses.asl20;
    mainProgram = "tidb-server";
  };
}
