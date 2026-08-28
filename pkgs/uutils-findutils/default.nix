{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-findutils";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "findutils";
    tag = finalAttrs.version;
    hash = "sha256-0M3sOHVsIKG3rPthikommvKvHB1Q1RohogjS9LT5yU0=";
  };

  cargoHash = "sha256-6M3kLNtvZ1nsCAkVJExQBWV72Bf9Kq5iei7SVpYsYio=";

  postInstall = ''
    rm $out/bin/testing-commandline
  '';

  checkFlags = [
    # assertion failed: deps.get_output_as_string().contains("./test_data/simple/subdir")
    "--skip=find::tests::test_find_newer_xy_before_changed_time"
  ];

  versionCheckProgram = "${placeholder "out"}/bin/find";
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/uutils/findutils/releases/tag/${finalAttrs.version}";
    description = "Rust implementation of findutils";
    homepage = "https://github.com/uutils/findutils";
    license = lib.licenses.mit;
    mainProgram = "find";
    platforms = lib.platforms.unix;
  };
})
