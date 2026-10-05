{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  perl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-ai";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "git-ai-project";
    repo = "git-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e4hJMjWoHRRycYekbcM5hLIyNnz7xSeIO2Hx5xz4jX0=";
  };

  cargoHash = "sha256-/a2YpqhN5hbrFJTcehEPkFH9Jsinqf4sYTRiN+OTqp4=";

  nativeBuildInputs = [ perl ];

  postPatch = ''
    substituteInPlace src/config.rs \
      --replace-fail '"/usr/bin/git"' '"${gitMinimal}/bin/git"'
    substituteInPlace src/authorship/virtual_attribution.rs \
      --replace-fail 'Command::new("git")' 'Command::new("${gitMinimal}/bin/git")'
  '';

  cargoBuildFlags = [
    "--bin"
    "git-ai"
  ];

  # Run a pure unit-test subset that needs no daemon/socket orchestration.
  cargoTestFlags = [
    "--lib"
    "uuid::"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Git extension for tracking AI-generated code in repositories";
    homepage = "https://github.com/git-ai-project/git-ai";
    changelog = "https://github.com/git-ai-project/git-ai/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "git-ai";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
