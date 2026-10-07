{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "riquito";
    repo = "tuc";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8nvWh/AGGAuv0ztM/+czHlv+6jbbepN2OR6D0Y2CyRc=";
  };

  cargoHash = "sha256-75YA8WOwM5AjBNNbxrI87rl2EW6liu0X6ZKW1zZaOPs=";

  meta = {
    description = "When cut doesn't cut it";
    mainProgram = "tuc";
    homepage = "https://github.com/riquito/tuc";
    license = lib.licenses.gpl3;
  };
})
