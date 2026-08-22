{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "presenterm";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mIJktrgBweaaLD2YaRcs0vP5hKRy/kMN/HEnwO323DA=";
  };

  cargoHash = "sha256-OlZXf8Wg32mXGDGbavLVf1ELoqqSmc8z9DNpvGOfAJ8=";

  checkFlags = [
    "--skip=external_snippet"
  ];

  meta = {
    description = "Terminal based slideshow tool";
    changelog = "https://github.com/mfontanini/presenterm/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/mfontanini/presenterm";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "presenterm";
  };
})
