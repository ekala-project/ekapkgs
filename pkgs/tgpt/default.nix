{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libx11,
}:

buildGoModule (finalAttrs: {
  pname = "tgpt";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-70BbII+cK9s+5yIFmpUV3pNqiTPSWfwLbrwNvvjkXrA=";
  };

  vendorHash = "sha256-oh1qKEmWoWK9fXgSfbHFgM8TWD14xNNRFw+YgqnXt00=";

  buildInputs = [ libx11 ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Remove tests which need network access
    rm src/providers/koboldai/koboldai_test.go

    # Remove helper test that includes Windows-specific package manager detection tests
    # (TestDetectPackageManager for Scoop/Chocolatey fails on Linux)
    rm src/helper/helper_test.go
  '';

  meta = {
    description = "ChatGPT in terminal without needing API keys";
    homepage = "https://github.com/aandrew-me/tgpt";
    changelog = "https://github.com/aandrew-me/tgpt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "tgpt";
  };
})
