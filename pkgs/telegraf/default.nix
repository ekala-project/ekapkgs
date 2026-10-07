{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "telegraf";
  version = "1.40.1";

  subPackages = [ "cmd/telegraf" ];

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "telegraf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xP7jfCwj3/tUCGZXbWRfOPfPoQk9T8NjzH4TrTULPlg=";
  };

  vendorHash = "sha256-6B84e7k+rK9jmhBbb+h1Qm/Y4P0fjb4oOjg+kc7JwzI=";
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
