{
  lib,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  stdenv,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  # build.rs embeds a LiteLLM pricing snapshot; the sandbox forbids the
  # download, so pass a pinned copy via CCUSAGE_PRICING_JSON_PATH. The pin must
  # match the tagged tree's flake.lock.
  litellmRev = "e73abe6c72785ad91d4927da26de3a5d1b54300b";
  litellm-pricing = fetchurl {
    url = "https://raw.githubusercontent.com/BerriAI/litellm/${litellmRev}/model_prices_and_context_window.json";
    hash = "sha256-+7FjGdybHhztlM1TLueoy47b2yLjEbElFIcmMwZ/dTc=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ccusage";
  version = "20.0.26";

  src = fetchFromGitHub {
    owner = "ccusage";
    repo = "ccusage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/vkFQCybsJEHdZCslEgowmOpsVNpO8L9Yk+eutvcLkg=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoHash = "sha256-sTqd8N04TPhuF6nlyZ3ivetleS5b2rPW5bsf4iCPjZw=";

  cargoBuildFlags = [
    "-p"
    "ccusage"
    "--bin"
    "ccusage"
  ];

  # Workspace tests need fixture crates and insta snapshots the tarball lacks.
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  env.RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-Wl,-dead_strip_dylibs";
  env.CCUSAGE_PRICING_JSON_PATH = litellm-pricing;
  env.CCUSAGE_VERSION = finalAttrs.version;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Analyze coding agent CLI token usage and costs from local data";
    homepage = "https://ccusage.com/";
    changelog = "https://github.com/ccusage/ccusage/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ccusage";
    platforms = lib.platforms.unix;
  };
})
