{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  sqlite,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arti";
  version = "2.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    tag = "arti-v${finalAttrs.version}";
    hash = "sha256-jOCFXlBI2xAzgpb7Fa8ap53SpDF6kcRGYnBXcu3vpk4=";
  };

  postPatch = ''
    substituteInPlace crates/arti/Cargo.toml \
      --replace-fail '"tokio-util"' '"dep:tokio-util"'
  '';

  buildAndTestSubdir = "crates/arti";
  cargoHash = "sha256-JK6ubp697jZ98ErNrZdFe0mXIez3lUZ5SmAHkyD97WQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    openssl
  ];

  buildFeatures = [ "full" ];

  checkFeatures = [
    "full"
    "experimental-api"
  ];

  checkFlags = [
    "--skip=reload_cfg::test::watch_single_file"
  ];

  env.ARTI_FS_DISABLE_PERMISSION_CHECKS = 1;

  meta = {
    description = "Implementation of Tor in Rust";
    mainProgram = "arti";
    homepage = "https://arti.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/blob/arti-v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
})
