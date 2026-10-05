{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "unreal-agent";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "unreallabsai";
    repo = "unreal-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fNGDRmDAPpBuOmea62Q7e2F3BVChnnrWnxwDsqalzyM=";
  };

  vendorHash = "sha256-JnIySSral40U188nsO+7zt/4404bAGQIXNiMz+/Fbyo=";

  subPackages = [ "cmd/unreal-agent-runner" ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
  ];

  # The runner exposes help but no version flag.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/unreal-agent-runner -h >/dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Async-first agent harness";
    homepage = "https://github.com/unreallabsai/unreal-agent";
    changelog = "https://github.com/unreallabsai/unreal-agent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "unreal-agent-runner";
    platforms = lib.platforms.unix;
  };
})
