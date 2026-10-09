{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cortex";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "cortexproject";
    repo = "cortex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qi+9MLjCrlN7u4WKweKiCn58H0/gr+8TblZkNRk+7Uw=";
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
