{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "multica";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "multica-ai";
    repo = "multica";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CANM8SyHw7oEgKeWYGWhOyS//pArVvypZSqjTjO2ro4=";
  };

  sourceRoot = "${finalAttrs.src.name}/server";

  subPackages = [ "cmd/multica" ];

  vendorHash = "sha256-ivrOEgNrH5Cw1ETXcpxy9CVVJuQohF2zm/9r8ED0bgk=";

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
