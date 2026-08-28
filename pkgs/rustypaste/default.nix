{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustypaste";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0x28oil0Cn/3ESZU9jN3tT68cTHErdWX3eefgXYLnuQ=";
  };

  cargoHash = "sha256-Oggu++740APpcTX0U7iXcbMWJosjdo5yeU/4QeVMFrs=";

  dontUseCargoParallelTests = true;

  checkFlags = [
    # requires internet access
    "--skip=paste::tests::test_paste_data"
    "--skip=server::tests::test_upload_remote_file"
    "--skip=util::tests::test_validate_remote_url_valid_http"
    "--skip=util::tests::test_validate_remote_url_valid_https"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Minimal file upload/pastebin service";
    homepage = "https://github.com/orhun/rustypaste";
    changelog = "https://github.com/orhun/rustypaste/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "rustypaste";
  };
})
