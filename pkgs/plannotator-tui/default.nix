{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "plannotator-tui";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "plannotator";
    repo = "plannotator-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DN3jRovKYUpT6Isu6B1HgKMB+v7KfELX7BRjxG/INRA=";
  };

  cargoHash = "sha256-CEExsInt7DmfqEAe5bXFsL++caiaBQoduSr+/X11I6g=";

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
