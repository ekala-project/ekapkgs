{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "trunk";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gQaUAY3A8LSIMjhO+9ch8yrswxkl+NqUrjeLekDR1ec=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-VkRN5kUQODutEu8uS495lLu5o5KlIaP6ATpA1/ugI0w=";

  meta = {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    license = lib.licenses.asl20;
  };
})
