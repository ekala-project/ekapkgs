{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jscpd";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "kucherenko";
    repo = "jscpd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j4f1jYpj3N7hnPxm1cq8nOvi7bBgohu6nm2y0gt4e6s=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoHash = "sha256-wFmQjNspdmeWc9k1yhQbQ0xTyXlz92DaH+NZlJUJ7bA=";

  cargoBuildFlags = [
    "-p"
    "jscpd"
  ];

  # Workspace tests exercise fixtures outside the rust/ source root.
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
    description = "Copy/paste detector for programming source code";
    homepage = "https://jscpd.dev";
    changelog = "https://github.com/kucherenko/jscpd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "jscpd";
    platforms = lib.platforms.all;
  };
})
