{
  lib,
  go,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "alertmanager";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/sh1MXMHNo8Rh+pIp9G/8rnEn4cWhe9Yn4fBiQ8LK4o=";
  };

  vendorHash = "sha256-f2oKca3FJ3EvS8jF4+MA3H6x3u5nITwVBkXY7wk2B3s=";

  postPatch = ''
    # Create minimal UI dist directory so Go embed directive succeeds
    mkdir -p ui/app/dist
    touch ui/app/dist/index.html
  '';

  subPackages = [
    "cmd/alertmanager"
    "cmd/amtool"
  ];

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/amtool --completion-script-bash > amtool.bash
    installShellCompletion amtool.bash
    $out/bin/amtool --completion-script-zsh > amtool.zsh
    installShellCompletion amtool.zsh
  '';

  meta = {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    changelog = "https://github.com/prometheus/alertmanager/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "alertmanager";
  };
})
