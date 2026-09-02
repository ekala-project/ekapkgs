{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  stdenv,
}:

buildGo126Module (finalAttrs: {
  pname = "telegraf";
  version = "1.39.3";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2Pt5lTRo8twIVoKP8BxJr8LIylZjFAdHYGc2vINyGNo=";
  };

  vendorHash = "sha256-Y+FHFWq6eVycNci/Br9WWfJUrBPTLG5xCp/WrA6uzR4=";
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
