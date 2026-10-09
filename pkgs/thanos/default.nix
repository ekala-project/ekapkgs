{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "thanos";
  version = "0.40.1";

  src = fetchFromGitHub {
    owner = "thanos-io";
    repo = "thanos";
    tag = "v${version}";
    hash = "sha256-g0xvtBwPoX906xHdyOEUfudio/9MZhkzdBp5FcATRsM=";
  };

  vendorHash = "sha256-ukKoiA7UhqDdMvAWYL5BGf6+FSPSkcRR/Scj5o/MMKc=";

  subPackages = "cmd/thanos";

  # Keep in sync with https://github.com/thanos-io/thanos/blob/main/.promu.yml
  tags = [
    "netgo"
    "slicelabels"
  ];

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Highly available Prometheus setup with long term storage capabilities";
    homepage = "https://github.com/thanos-io/thanos";
    changelog = "https://github.com/thanos-io/thanos/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "thanos";
  };
}
