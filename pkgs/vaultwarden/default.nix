{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv ? null,
  dbBackend ? "sqlite_system",
  mariadb-connector-c ? null,
  libpq ? null,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vaultwarden";
  version = "1.37.3";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    tag = finalAttrs.version;
    hash = "sha256-T2sTVsBCvsvgxjlTeBPSvA96mJ7TLYqLNvldCI73by0=";
  };

  cargoHash = "sha256-gUQxnGPo8jYTfG+Zsz8W35h8lkYDxI3mGnCdxNXYB4k=";

  env.VW_VERSION = finalAttrs.version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ]
  ++ lib.optional (dbBackend == "mysql" && mariadb-connector-c != null) mariadb-connector-c
  ++ lib.optional (dbBackend == "postgresql" && libpq != null) libpq
  ++ lib.optional (dbBackend == "sqlite_system") sqlite;

  buildFeatures = dbBackend;

  meta = {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    license = lib.licenses.agpl3Only;
    mainProgram = "vaultwarden";
  };
})
