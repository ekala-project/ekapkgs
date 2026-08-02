{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-findutils";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "findutils";
    tag = finalAttrs.version;
    hash = "sha256-ILMInyjOMYlgPxrOjvLoBfkcaZ4aj6GeA/jiGPpNjiI=";
  };

  cargoHash = "sha256-/rQTcyRXtluPKPuuZKn/qD/3U0PQLIqyq777/ww3q/0=";

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
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
