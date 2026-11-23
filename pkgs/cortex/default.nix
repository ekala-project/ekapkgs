{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cortex";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "cortexproject";
    repo = "cortex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gA4o34YF9fMen1SotZSC5ZQjBzexqSFRkBO79O9Tu4o=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/cortex"
    "cmd/query-tee"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Branch=release-${lib.versions.majorMinor finalAttrs.version}"
    "-X main.Revision=unknown"
  ];

  meta = {
    description = "Horizontally scalable, highly available multi-tenant Prometheus";
    homepage = "https://cortexmetrics.io";
    changelog = "https://github.com/cortexproject/cortex/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "cortex";
  };
})
