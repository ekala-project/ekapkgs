{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chainlink";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dollspace-gay";
    repo = "chainlink";
    tag = "chainlink-${finalAttrs.version}";
    hash = "sha256-2n+cM1ADmeDrKZKjMY5Ct4mVxl38as4iu1Y4ZSCuBho=";
  };

  # The Rust crate is in the chainlink subdirectory.
  cargoRoot = "chainlink";
  buildAndTestSubdir = "chainlink";

  cargoHash = "sha256-WmV6PRSuzdoCMXy4LMSMdHsSbI+A8jx89lwUt64DWmc=";

  # Upstream Cargo.toml version doesn't match release tags; update only within
  # [package].
  postPatch = ''
    sed -i '/^\[package\]/,/^\[/{s/^version = ".*"/version = "${lib.versions.pad 3 finalAttrs.version}"/}' chainlink/Cargo.toml
  '';

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Simple, lean issue tracker CLI designed for AI-assisted development";
    homepage = "https://github.com/dollspace-gay/chainlink";
    changelog = "https://github.com/dollspace-gay/chainlink/releases/tag/chainlink-${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "chainlink";
    platforms = lib.platforms.all;
  };
})
