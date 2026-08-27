{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "zfind";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "laktak";
    repo = "zfind";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zp2YrrvghmXy0LPxCSkOxYwrmoGabTKCD5CiFl3XCOU=";
  };

  vendorHash = "sha256-kSqzjRXCr92c6CzQpRf3Ny+SEp3O15fKk0NgmTHtxSY=";

  ldflags = [
    "-X"
    "main.appVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "CLI for file search with SQL like syntax";
    homepage = "https://github.com/laktak/zfind";
    changelog = "https://github.com/laktak/zfind/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "zfind";
    maintainers = [ ];
  };
})
