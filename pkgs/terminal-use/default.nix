{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwinMinVersionHook,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminal-use";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "flipbit03";
    repo = "terminal-use";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x4wK6Vw7qMkRYRRqgaNvUh8lSngodw4nX/BUzmqOtmU=";
  };

  cargoHash = "sha256-KapRznQ67o8H0aIMGvCMojwF/qSZ3rSlx6SEKbi12ig=";

  # `tu self update` rewrites its own binary (or shells out to `cargo install`),
  # which is wrong for a Nix-managed install. Make it defer to Nix.
  patches = [ ./disable-self-update.patch ];

  # The Cargo manifest ships a placeholder 0.0.0 version rewritten at tag time.
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    (darwinMinVersionHook "11.0")
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Headless virtual terminal for AI agents";
    longDescription = ''
      tu is a full terminal emulator for AI agents. It spawns interactive
      terminal apps and lets an agent read the rendered screen (as text or PNG
      screenshot) and drive the keyboard and mouse — no GUI, X server, or
      display needed.
    '';
    homepage = "https://github.com/flipbit03/terminal-use";
    changelog = "https://github.com/flipbit03/terminal-use/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tu";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
