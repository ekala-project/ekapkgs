{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  curl,
  openssl,
  stdenv,
}:

let
  cargoVersion = "0.93.0";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-c";
  version = "0.10.19";

  src = fetchCrate {
    inherit (finalAttrs) pname;
    version = "${finalAttrs.version}+cargo-${cargoVersion}";
    hash = "sha256-PrBmB+0tmU2MAUnRr+wx4g9hu0Y9i6WfR8U89bwiLVY=";
  };

  cargoHash = "sha256-EM/vAfW/ucOfK/XmAQn9Zk75eFb7pp8uZoByKbALCyo=";

  nativeBuildInputs = [
    pkg-config
    (lib.getDev curl)
  ];

  buildInputs = [
    openssl
    curl
  ];

  meta = {
    description = "Cargo subcommand to build and install C-ABI compatible dynamic and static libraries";
    homepage = "https://github.com/lu-zero/cargo-c";
    license = lib.licenses.mit;
  };
})
