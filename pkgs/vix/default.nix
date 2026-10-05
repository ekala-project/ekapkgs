{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "vix";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "get-vix";
    repo = "vix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MiaBrOLpxulx6qgJvvgeg+K2TTzYf6G/E8F8x2e3rTk=";
  };

  # Source already ships a vendor/ directory.
  vendorHash = null;

  subPackages = [
    "cmd/vix"
    "cmd/vixd"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Sleek, fast and token-efficient AI coding agent";
    homepage = "https://github.com/get-vix/vix";
    changelog = "https://github.com/get-vix/vix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "vix";
    platforms = lib.platforms.unix;
  };
})
