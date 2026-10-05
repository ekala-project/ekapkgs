{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "mardi-gras";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "quietpublish";
    repo = "mardi-gras";
    tag = "v${finalAttrs.version}";
    hash = "sha256-72SfbYfuUgTL+qj1q7N5ZJ60U7xPIUWvDGt1TZ+VjI8=";
  };

  vendorHash = "sha256-wDr642Vz4lGGT7X1NPawtCgjEj2BhfCfIPJ6TMpc3/E=";

  subPackages = [ "cmd/mg" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = [ "--version" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Terminal UI for Beads issue tracking with a parade-inspired workflow view";
    homepage = "https://github.com/quietpublish/mardi-gras";
    changelog = "https://github.com/quietpublish/mardi-gras/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "mg";
    platforms = lib.platforms.unix;
  };
})
