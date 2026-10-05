{
  fetchFromGitHub,
  lib,
  mold,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gfold";
  version = "2026.9.0";

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = "gfold";
    tag = finalAttrs.version;
    hash = "sha256-NT7GqzVvALHOoMaqn1btrH0XBswEJwyZEK9W9a4WTWk=";
  };

  nativeBuildInputs = [ mold ];

  cargoHash = "sha256-LvUr3T2XOm7mHUjDE5HgBQiHI3Sq9oW7wxAjj2IXQ80=";

  meta = {
    description = "CLI tool to help keep track of your Git repositories, written in Rust";
    homepage = "https://github.com/nickgerace/gfold";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "gfold";
  };
})
