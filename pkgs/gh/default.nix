{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  installShellFiles,
  stdenv,
  makeWrapper,
}:

buildGo126Module (finalAttrs: {
  pname = "gh";
  version = "2.98.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2MktrI8FEvGkU2/cC6vrPtujl8fszuxz+Ey30WjRjhg=";
  };

  vendorHash = "sha256-fhFsu/LjLNFwexSfUsd4X74UD+AQojLcdxU5IqOi3GY=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w -X github.com/cli/cli/v${lib.versions.major finalAttrs.version}/internal/build.Date=nixpkgs" GH_VERSION=${finalAttrs.version} bin/gh manpages
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    installBin bin/gh
    wrapProgram $out/bin/gh \
      --set-default GH_TELEMETRY false

    installManPage share/man/*/*.[1-9]

    installShellCompletion --cmd gh \
      --bash <($out/bin/gh completion -s bash) \
      --fish <($out/bin/gh completion -s fish) \
      --zsh <($out/bin/gh completion -s zsh)

    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    changelog = "https://github.com/cli/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gh";
  };
})
