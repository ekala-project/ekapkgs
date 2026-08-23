{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-geiger";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "geiger-rs";
    repo = "cargo-geiger";
    tag = "cargo-geiger-${finalAttrs.version}";
    hash = "sha256-dZ71WbTKsR6g5UhWuJNfNAAqNNxbTgwL5fsgkm50BaM=";
  };

  cargoHash = "sha256-GgCmUNOwvyTB82Y/ddgJIAb1SpO4mRPjECqCagJ8GmE=";

  postPatch = ''
    # https://github.com/geiger-rs/cargo-geiger/pull/562
    # Fix unused import warning which is treated as an error
    substituteInPlace cargo-geiger/tests/integration_tests.rs \
      --replace-fail "use std::env;" ""
  '';

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # skip tests with networking or other failures
  checkFlags = [
    # panics
    "--skip=serialize_test2_quick_report"
    "--skip=serialize_test3_quick_report"
    "--skip=serialize_test6_quick_report"
    "--skip=serialize_test2_report"
    "--skip=serialize_test3_report"
    "--skip=serialize_test6_report"
    # requires networking
    "--skip=test_package::case_2"
    "--skip=test_package::case_3"
    "--skip=test_package::case_6"
    "--skip=test_package::case_9"
    # panics, snapshot assertions fails
    "--skip=test_package_update_readme::case_2"
    "--skip=test_package_update_readme::case_3"
    "--skip=test_package_update_readme::case_5"
  ];

  meta = {
    description = "Detects usage of unsafe Rust in a Rust crate and its dependencies";
    homepage = "https://github.com/geiger-rs/cargo-geiger";
    changelog = "https://github.com/geiger-rs/cargo-geiger/blob/cargo-geiger-${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "cargo-geiger";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
})
