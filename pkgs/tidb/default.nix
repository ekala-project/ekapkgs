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
  version = "26.3.24";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "tidb";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-OJ+g8N6B0RoA7/U3dg7PGj6bhCpqPfX3wbNJV4Bg6gI=";
  };

  vendorHash = "sha256-Ueyb5H45y0P/y9xFQ5jwfmFUw3eZZ3Bwlhu54ex+b2I=";

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
