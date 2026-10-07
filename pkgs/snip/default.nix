{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "snip";
  version = "0.25.2";

  src = fetchFromGitHub {
    owner = "edouard-claude";
    repo = "snip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uyd8GcHX1HhdSdcRtYyygxkfYXBcU3RuAUqNwHMFRmE=";
  };

  vendorHash = "sha256-gfCZn2B4o4nz/NL8QIrl76yUc4g66RDCr1RVlGsI9rk=";

  nativeCheckInputs = [ gitMinimal ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI proxy that reduces LLM token consumption by filtering verbose shell output";
    homepage = "https://github.com/edouard-claude/snip";
    changelog = "https://github.com/edouard-claude/snip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "snip";
  };
})
