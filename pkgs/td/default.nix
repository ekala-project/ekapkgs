{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "td";
  version = "0.66.0";

  src = fetchFromGitHub {
    owner = "marcus";
    repo = "td";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n6Gv7nnepwsqw8XMHAiXnusiOpaSx9d1+nZahlUnCfE=";
  };

  vendorHash = "sha256-/IWBYL+WfLz7vDdUs//0KY8rb9mOv4S1jBXCZbYxJRo=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Minimalist CLI for tracking tasks across AI coding sessions";
    homepage = "https://github.com/marcus/td";
    changelog = "https://github.com/marcus/td/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "td";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
