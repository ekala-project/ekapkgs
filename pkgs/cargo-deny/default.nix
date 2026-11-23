{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-deny";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    tag = finalAttrs.version;
    hash = "sha256-Yjt2tjGtnmh3Ljf+Ikf27WzTEZ7ge0vL2i0n9oqP+Zo=";
  };

  cargoHash = "sha256-cm5TRk2bqI2CmAbLhtPI/SQKhfmvSMC9S52EXpu+43k=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require internet access

  meta = {
    description = "Cargo plugin for linting your dependencies";
    mainProgram = "cargo-deny";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
  };
})
