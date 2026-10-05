{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  zstd,
  dbus,
  stdenv,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "but";
  version = "0.22.3";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-nW3yCbpbIhawLQVV+DptzGYiFBSKcyAP89NtDWHJM+0=";
  };

  cargoHash = "sha256-XRc2yok9K7f/vRAqgO78JUq/U36XSiUeOINupfOOSjw=";

  # Upstream pins a specific stable channel; allow building with nixpkgs' rustc.
  postPatch = ''
    rm -f rust-toolchain.toml
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    sqlite
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ dbus ];

  env = {
    VERSION = finalAttrs.version;
    CHANNEL = "release";
    OPENSSL_NO_VENDOR = "1";
    ZSTD_SYS_USE_PKG_CONFIG = "1";
    TS_RS_EXPORT_DIR = "/build/ts-rs";
  };

  cargoBuildFlags = [ "--package=but" ];
  buildFeatures = [ "but/packaged-but-distribution" ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "GitButler CLI: virtual branches and AI-assisted Git workflow from the terminal";
    homepage = "https://github.com/gitbutlerapp/gitbutler";
    changelog = "https://github.com/gitbutlerapp/gitbutler/releases/tag/release/${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    mainProgram = "but";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
