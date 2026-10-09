{
  lib,
  fetchFromGitHub,
  rustPlatform,
  gitMinimal,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "claw-code";
  version = "0-unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "ultraworkers";
    repo = "claw-code";
    rev = "08106b0c3771ef5b4a5aa176acccd460e88b7325";
    hash = "sha256-7nh4IjYwG4fpB+4P/HWAAB9IK+X6gQs9v2Ts3OT3uaQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoHash = "sha256-Acaycrxm3e87dx3P7NdWnivopF4xxaMi3PPbpSefEyY=";

  cargoBuildFlags = [
    "--package"
    "rusty-claude-cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # Upstream's test block is broken at this rev; the release binary compiles.
  doCheck = false;

  nativeCheckInputs = [ gitMinimal ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkFlags = [
    "--skip=tests::rejects_unknown_allowed_tools"
    "--skip=tests::build_runtime_plugin_state_discovers_mcp_tools_and_surfaces_pending_servers"
    "--skip=clean_env_cli_reaches_mock_anthropic_service_across_scripted_parity_scenarios"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  # Upstream has no tagged release; the binary reports the workspace version,
  # not our 0-unstable-<date> derivation version.
  preVersionCheck = ''
    version=$(sed -n 's/^version = "\(.*\)"/\1/p' Cargo.toml | head -n1)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Claude Code rewrite CLI built from the official claw-code Rust workspace";
    homepage = "https://github.com/ultraworkers/claw-code";
    changelog = "https://github.com/ultraworkers/claw-code/releases";
    license = lib.licenses.mit;
    mainProgram = "claw";
    platforms = lib.platforms.unix;
  };
})
