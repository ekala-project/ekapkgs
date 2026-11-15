{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "plannotator-tui";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "plannotator";
    repo = "plannotator-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I5Gc/YdpybsWvgYNELKLSRGszFJBiyg4C/MKAAQ8CPo=";
  };

  cargoHash = "sha256-umYlecdHYSr1Jzbi/0oI4ULRi5lf9O8kybtb5DeeWxo=";

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Annotate Markdown in the terminal and send feedback to coding agents";
    homepage = "https://github.com/plannotator/plannotator-tui";
    changelog = "https://github.com/plannotator/plannotator-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "plannotator-tui";
    platforms = lib.platforms.unix;
  };
})
