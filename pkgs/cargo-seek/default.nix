{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-seek";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "tareqimbasher";
    repo = "cargo-seek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WL1S2oU3/T9pEI4rgzT2dJ/ZTiwS/BgraW1MmZ5MQl0=";
  };

  cargoHash = "sha256-cXZvuMcNGNWU61ll2dAFxPKWujJNzXpC8aP5vxDONkY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Terminal user interface for searching, adding and installing cargo crates";
    homepage = "https://github.com/tareqimbasher/cargo-seek";
    changelog = "https://github.com/tareqimbasher/cargo-seek/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "cargo-seek";
  };
})
