{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  dbus,
  pkg-config,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nono";
  version = "0.79.0";

  src = fetchFromGitHub {
    owner = "nolabs-ai";
    repo = "nono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YDl52T2xY0XbBO5YdNa5uGvvvk7mqr1JtAQOLTXspFw=";
  };

  cargoHash = "sha256-ffwJDKFoDMfZYYNWO4SWezdbD5Y8SR7S+a+qSQEgG9w=";

  # `if let` guards in match arms require Rust >= 1.95; rewrite the single use
  # until nixpkgs ships a new enough rustc.
  patches = [ ./no-if-let-guard.patch ];

  # keyring uses sync-secret-service (dbus) on Linux, apple-native on Darwin.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ dbus ];
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Kernel-enforced agent sandbox with capability-based isolation and secure key management";
    homepage = "https://nono.sh/";
    changelog = "https://github.com/nolabs-ai/nono/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "nono";
    platforms = lib.platforms.unix;
  };
})
