{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-screenshot";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-JYV6U8mtl/eaOG7PfT1IuVUEt7yFQf4MFVG7naC0iKw=";
  };

  cargoHash = "sha256-q0RJST1yeqPBjU5MseNZIrZw+brfDtQLKiw7wyViflE=";

  nativeBuildInputs = [
    just
    pkg-config
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  meta = {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
})
