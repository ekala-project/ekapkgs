{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "telegraf";
  version = "1.40.4";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/PjEL1rxGFJgE3Jh2D4vj1KFGdJJb0gnmFiFSrLIx5E=";
  };

  vendorHash = "sha256-oKnDXoTBrVl3qrdhl94MfW/Xj0JN5VXC15eCOOd3pO0=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/influxdata/telegraf/internal.Commit=${finalAttrs.src.rev}"
    "-X=github.com/influxdata/telegraf/internal.Version=${finalAttrs.version}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch32 [
    "-extldflags"
    "-Wl,--long-plt"
  ];

  meta = {
    description = "Plugin-driven server agent for collecting & reporting metrics";
    mainProgram = "telegraf";
    homepage = "https://www.influxdata.com/time-series-platform/telegraf/";
    changelog = "https://github.com/influxdata/telegraf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
})
