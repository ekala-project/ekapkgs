{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module (finalAttrs: {
  pname = "lazygit";
  version = "0.64.0";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iN1QEZBS4TxfBMe3+NoYx33wIrgLUSG7I8rNBSTinfc=";
  };

  vendorHash = null;
  subPackages = [ "." ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.buildSource=nix"
  ];

  meta = {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    changelog = "https://github.com/jesseduffield/lazygit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lazygit";
  };
})
