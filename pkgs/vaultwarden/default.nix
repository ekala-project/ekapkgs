{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv ? null,
  dbBackend ? "sqlite_system",
  libmysqlclient ? null,
  libpq ? null,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vaultwarden";
  version = "1.37.1";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    tag = finalAttrs.version;
    hash = "sha256-QS9dUOlId4LT6rNgLwVxShX3xpnykpbiFsc0x88Bojc=";
  };

  cargoHash = "sha256-sza4ZQz2+QJJJ03Upt6sGXAv+1VPImN2qZHXaTSALFQ=";

  env.VW_VERSION = finalAttrs.version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ]
  ++ lib.optional (dbBackend == "mysql" && libmysqlclient != null) libmysqlclient
  ++ lib.optional (dbBackend == "postgresql" && libpq != null) libpq
  ++ lib.optional (dbBackend == "sqlite_system") sqlite;

  buildFeatures = dbBackend;

  meta = {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    mainProgram = "vaultwarden";
  };
})
