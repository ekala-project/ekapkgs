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

  # mautrix-go's crypto backend links libolm via cgo. libolm is marked
  # insecure in nixpkgs (deprecated upstream, timing side-channels in its
  # AES/SHA primitives). Accepted here because Matrix is an optional chat
  # backend and the pure-Go goolm alternative is still experimental.
  buildInputs = [
    (olm.overrideAttrs (old: {
      meta = old.meta // {
        knownVulnerabilities = [ ];
      };
    }))
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
