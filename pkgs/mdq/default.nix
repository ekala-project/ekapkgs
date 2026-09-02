{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdq";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "yshavit";
    repo = "mdq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3WIw0n7fRJqOYpkdLh949JpbKKGUVcnnc+On2aWBXTE=";
  };

  cargoHash = "sha256-3HXPN0E4HRMVtHZbmmUO+2bPd2C8rTjTVHGcFPM2OFY=";

  meta = {
    description = "Like jq but for Markdown: find specific elements in a md doc";
    homepage = "https://github.com/yshavit/mdq";
    changelog = "https://github.com/yshavit/mdq/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "mdq";
  };
})
