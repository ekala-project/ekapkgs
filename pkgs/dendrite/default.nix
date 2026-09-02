{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "matrix-dendrite";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "dendrite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VxQ5fuGzkEL371TmnDQ0wNqqmfzupmsTX/v+eFthj8E=";
  };

  vendorHash = "sha256-QUztOoOesECAhwh4whzvrc43rJxjtPaEICUHno2DId0=";

  subPackages = [
    "cmd/dendrite"
    "cmd/create-account"
    "cmd/generate-config"
    "cmd/generate-keys"
    "cmd/resolve-state"
  ];

  doCheck = false;

  meta = {
    homepage = "https://element-hq.github.io/dendrite";
    mainProgram = "dendrite";
    description = "Second-generation Matrix homeserver written in Go";
    changelog = "https://github.com/element-hq/dendrite/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
  };
})
