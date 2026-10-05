{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  stdenv,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openfang";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "RightNow-AI";
    repo = "openfang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zz+lFS2bLdb7F4/Ogdc2xrr9rACEzCijdfeAEXIUmnw=";
  };

  cargoHash = "sha256-MGqLTo/0kUcVOL/MZo3sRgLH9ceSLASvJyl0Ou4giY8=";

  cargoBuildFlags = [
    "--package"
    "openfang-cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env = {
    OPENSSL_NO_VENDOR = "1";
    CARGO_PROFILE_RELEASE_LTO = "off";
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "16";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Open-source Agent OS built in Rust, CLI for the OpenFang platform";
    homepage = "https://github.com/RightNow-AI/openfang";
    changelog = "https://github.com/RightNow-AI/openfang/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "openfang";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
