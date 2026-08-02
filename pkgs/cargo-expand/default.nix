{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-expand";
  version = "1.0.124";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    tag = finalAttrs.version;
    hash = "sha256-deGIcij3Tczsqc0HTBGUbncdUXKP+FGj5R+2fevQULA=";
  };

  cargoHash = "sha256-MYaKNoz8h5bt0/Z+8PwLKZDvIWUUCfsvB5vibMaDmf4=";

  doInstallCheck = true;

  meta = {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ ];
    mainProgram = "cargo-expand";
  };
})
