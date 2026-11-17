{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "multica";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "multica-ai";
    repo = "multica";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W5yHXSsMuiiIwwADCrAVAp+C0Ww4nCeo/x31baj7rWM=";
  };

  sourceRoot = "${finalAttrs.src.name}/server";

  subPackages = [ "cmd/multica" ];

  vendorHash = "sha256-kFDWoj8uRzVyOePCl9tGVarsuYMe8gWHT162AXW7wmU=";

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Command-line interface for the Multica platform";
    homepage = "https://github.com/multica-ai/multica";
    changelog = "https://github.com/multica-ai/multica/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    mainProgram = "multica";
    platforms = lib.platforms.unix;
  };
})
