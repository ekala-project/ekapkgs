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
  version = "4.17.0";

  src = fetchFromGitHub {
    owner = "junhoyeo";
    repo = "tokscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YgJxly0r0p8iGu2dLuMmsfHR/Br0Wbq4Tjkj3SbzR8Q=";
  };

  cargoHash = "sha256-sJ9sSDP5AYEbRwZMEawNQZMC4/z91PfTqx6beOqVO28=";

  env.OPENSSL_NO_VENDOR = "1";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # Tests need network access.
  doCheck = false;

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
