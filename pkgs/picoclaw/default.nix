{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "picoclaw";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "picoclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QYfHXIHJjeZJdkhGNNhdO91Q8EFgSP+ubqGJ8VgTEtc=";
  };

  vendorHash = "sha256-mN+eI8JtqIqBCxheVlTw7nL200WgVAd8xLhUsrYdohE=";

  buildInputs = [
    olm
  ];

  postPatch = ''
    # go:embed in cmd/picoclaw/internal/onboard/command.go expects a workspace
    # directory copied there by go:generate, which doesn't run during nix builds.
    cp -r workspace cmd/picoclaw/internal/onboard/workspace
  '';

  subPackages = [ "cmd/picoclaw" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sipeed/picoclaw/pkg/config.Version=${finalAttrs.version}"
  ];

  # Tests require runtime configuration and network access.
  doCheck = false;

  doInstallCheck = true;
  versionCheckProgramArg = [ "version" ];
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Tiny, fast, deployable AI assistant";
    homepage = "https://picoclaw.io";
    changelog = "https://github.com/sipeed/picoclaw/releases";
    license = lib.licenses.mit;
    mainProgram = "picoclaw";
    platforms = lib.platforms.unix;
  };
})
