{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tokscale";
  version = "4.23.1";

  src = fetchFromGitHub {
    owner = "junhoyeo";
    repo = "tokscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/WPLF6NlTplZeZ24vt8XUGC8DCQ4X5sohTsb5cpBAd8=";
  };

  cargoHash = "sha256-ckkiqN/Aue1lL0rlRbV2gHInK+b7hxgA41sBJNySfz4=";

  env.OPENSSL_NO_VENDOR = "1";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Tests need network access.

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "CLI and TUI for AI token usage analytics";
    homepage = "https://github.com/junhoyeo/tokscale";
    changelog = "https://github.com/junhoyeo/tokscale/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tokscale";
    platforms = lib.platforms.unix;
  };
})
