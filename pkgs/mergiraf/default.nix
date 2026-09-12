{
  lib,
  fetchFromCodeberg,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mergiraf";
  version = "0.19.0";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eBq7xNuV0Z6DVdgaKVgk07WmGEgu7k14hkvVWwtplOo=";
  };

  cargoHash = "sha256-dxTR5mvov5FvnkIZalDMnl99BH8sBx6EsqJyGRMiPfQ=";

  doCheck = false; # needs git which is broken in ekapkgs

  cargoBuildFlags = [
    # don't install the `mgf_dev`
    "--bin"
    "mergiraf"
  ];

  meta = {
    description = "Syntax-aware git merge driver for a growing collection of programming languages and file formats";
    homepage = "https://mergiraf.org/";
    downloadPage = "https://codeberg.org/mergiraf/mergiraf";
    changelog = "https://codeberg.org/mergiraf/mergiraf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "mergiraf";
  };
})
