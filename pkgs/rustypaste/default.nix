{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustypaste";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-K8hFpIPk53N4yrA7Q5HvRmEtUw03Z7syhtmJ17epaQM=";
  };

  cargoHash = "sha256-PsjQ6or7ID74U60E56g+wOLWy04e28lXiS1Q/mbaSZM=";

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
