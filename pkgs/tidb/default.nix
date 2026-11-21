{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
}:

# TiDB's `pkg/util/hack` package aborts unless the toolchain's minor version
# matches exactly (go1.25); the default ekapkgs go (1.27) panics at startup.
buildGoModule.override { go = go.v1_25; } (finalAttrs: {
  pname = "tidb";
  version = "26.3.23";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "tidb";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Vc5FgDqfNOTHe9gpAziVC/Mr3/9hChbenJ9kv5Pf9WA=";
  };

  vendorHash = "sha256-TpzuILLp9ICdp30xQNzpXC7x7H1TCizcaf7xPF7xTto=";

  ldflags = [
    "-X github.com/pingcap/tidb/pkg/parser/mysql.TiDBReleaseVersion=${finalAttrs.version}"
    "-X github.com/pingcap/tidb/pkg/util/versioninfo.TiDBEdition=Community"
  ];

  subPackages = [ "cmd/tidb-server" ];

  meta = {
    description = "Open-source, cloud-native, distributed, MySQL-Compatible database for elastic scale and real-time analytics";
    homepage = "https://pingcap.com";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "tidb-server";
  };
})
