{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tgrab";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ryoppippi";
    repo = "tgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5zZ6QgdDDIO7KlZsU6I7r+cgLXYKjfgYqBCzUJjXpQ=";
  };

  cargoHash = "sha256-r2IiZ2ud0ABQrmGxtqZRu2no9lQABoIKr5g0hqmjgDI=";

  env.RUSTFLAGS = "--cfg reqwest_unstable";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/tgrab --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Fetch text content from YouTube, Twitter/X, and Bluesky";
    homepage = "https://github.com/ryoppippi/tgrab";
    changelog = "https://github.com/ryoppippi/tgrab/releases";
    license = lib.licenses.mit;
    mainProgram = "tgrab";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
