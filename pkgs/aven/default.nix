{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  gitMinimal,
  sqlite,
  libredirect,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aven";
  version = "0.1.44";

  src = fetchFromGitHub {
    owner = "raine";
    repo = "aven";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSOVHoR7v4xafqLPKYzDof68Z/OloiVRdfP0/g4rxI4=";
  };

  cargoHash = "sha256-ohqHhF6YlE3/0++/Hpi++v7yaLTF9CFH2zHJHEX1nvU=";

  # `launchctl print gui/<uid>/...` fails for the darwin build user, which has
  # no per-user launchd domain. Degrade to "unknown" instead.
  patches = [ ./daemon-status-unknown-without-gui-domain.patch ];

  # Some tests infer the project key from the checkout directory name
  # ("aven" -> "AVN"), but Nix unpacks into "source".
  postUnpack = ''
    mv "$sourceRoot" aven
    export sourceRoot=aven
  '';

  # Only build the CLI crate, not the aven-uniffi mobile bindings.
  cargoBuildFlags = [
    "--package"
    "aven"
  ];

  # Compiling the 130k-line crate with --test in release mode OOMs on some
  # builders; debug keeps peak memory lower.
  checkType = "debug";
  env.RUST_MIN_STACK = "4194304";

  postInstall = ''
    install -d $out/share/aven
    cp -r skills $out/share/aven/skills
  '';

  # git: tests infer the project from the checkout's git repo.
  # sqlite: attachment tests shell out to `sqlite3`.
  # cacert: rustls-native-certs fails without system CA certs in the sandbox.
  nativeCheckInputs = [
    cacert
    gitMinimal
    sqlite
  ];

  checkFlags = [
    "--skip=local_calendar_dates_use_offsets_across_daylight_saving_boundaries"
    "--test-threads=1"
    "--skip=tui::app::tests::custom_commands"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--skip=sync_pair_copy_delivers_only_to_clipboard_without_qr_capacity_limit"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    git init -q .
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    echo UTC > "$TMPDIR/timezone"
    export NIX_REDIRECTS=/etc/timezone=$TMPDIR/timezone
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Local-first task manager for power users and agents";
    homepage = "https://github.com/raine/aven";
    changelog = "https://github.com/raine/aven/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "aven";
    platforms = lib.platforms.unix;
  };
})
