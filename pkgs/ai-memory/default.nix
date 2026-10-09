{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  cacert,
  makeBinaryWrapper,
  coreutils,
  curl,
  findutils,
  gawk,
  gitMinimal,
  sed,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  cliFlags = [
    "--package"
    "ai-memory-cli"
  ];

  # Tools the POSIX hook scripts call; they run from agent configs with
  # whatever PATH the agent happens to have.
  hookPath = lib.makeBinPath [
    coreutils
    curl
    findutils
    gawk
    gitMinimal
    sed
  ];
in
rustPlatform.buildRustPackage {
  pname = "ai-memory";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "akitaonrails";
    repo = "ai-memory";
    tag = "v2.5.0";
    hash = "sha256-taFkL1TxkKSdBylfMLUrVlw3egoNwOSh3rulltjx48U=";
  };

  cargoHash = "sha256-V1CeZBjgXmy1u0+1ZJcqKemAKl+LJZP/83vdthWjAq4=";

  cargoBuildFlags = cliFlags;
  cargoTestFlags = cliFlags ++ [
    "--bin"
    "ai-memory"
  ];

  # Expect "ai-memory" in current_exe(), the test binary is ai_memory-<hash>.
  checkFlags = map (t: "--skip=commands::install_hooks::tests::${t}") [
    "antigravity_apply_is_idempotent"
    "cursor_apply_is_idempotent"
    "kimi_code_apply_is_idempotent"
    "kimi_code_apply_preserves_providers_and_third_party_hooks"
  ];

  # build.rs would otherwise try to download the tailwind CLI for the web UI.
  env.TAILWIND_SKIP = "1";

  # `install-hooks`/`setup-agent` probe fixed FHS locations for the bundled
  # hook scripts; point the native-package candidate at our share/ dir.
  postPatch = ''
    substituteInPlace crates/ai-memory-cli/src/commands/{install_hooks,setup_agent}.rs \
      --replace-fail '"/usr/share/ai-memory/hooks/{sub}"' "\"$out/share/ai-memory/hooks/{sub}\""
    substituteInPlace crates/ai-memory-cli/src/commands/install_hooks.rs \
      --replace-fail '"/usr/share/ai-memory/hooks/claude-code"' "\"$out/share/ai-memory/hooks/claude-code\""
  '';

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  # reqwest loads native roots in the mcp_bridge test
  nativeCheckInputs = [ cacert ];

  postInstall = ''
    mkdir -p $out/share/ai-memory
    cp -r hooks $out/share/ai-memory/

    # Hook entry points are `#!/bin/sh` and locate _lib.sh via dirname before
    # anything else runs, so PATH has to be fixed up in the shebang line.
    for hook in $out/share/ai-memory/hooks/*/*.sh; do
      substituteInPlace "$hook" --replace-fail '#!/bin/sh' \
        '#!/bin/sh
    PATH=${hookPath}:$PATH'
    done

    installShellCompletion --cmd ai-memory \
      --bash <($out/bin/ai-memory completions bash) \
      --fish <($out/bin/ai-memory completions fish) \
      --zsh <($out/bin/ai-memory completions zsh)
  '';

  # git is shelled out to from several crates (wiki history, repo routing,
  # workstreams); wrap instead of patching every Command::new("git").
  postFixup = ''
    wrapProgram $out/bin/ai-memory --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Long-term memory for AI coding agents";
    homepage = "https://github.com/akitaonrails/ai-memory";
    changelog = "https://github.com/akitaonrails/ai-memory/releases/tag/v2.5.0";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "ai-memory";
    platforms = lib.platforms.unix;
  };
}
