{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "agent-deck";
  version = "1.16.16";

  src = fetchFromGitHub {
    owner = "asheshgoplani";
    repo = "agent-deck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+0T8ZJP+7W+QOT1dgVVmg46CCzM1O1UIg1+4CL8pMPE=";
  };

  vendorHash = "sha256-ZIBWsEa6IpoW66/kd40UNihBrbo5yjCsRIQatCbt4q8=";

  subPackages = [ "cmd/agent-deck" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  # Upstream's suite launches the full TUI and is timing/network sensitive.
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "AI agent command center";
    homepage = "https://github.com/asheshgoplani/agent-deck";
    changelog = "https://github.com/asheshgoplani/agent-deck/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "agent-deck";
    platforms = lib.platforms.unix;
  };
})
