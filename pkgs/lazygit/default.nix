{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module (finalAttrs: {
  pname = "lazygit";
  version = "0.64.1";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UYyIrSHk+efKvHvxQs7FsOGA7e0uM9mg+1O1WRJIeEU=";
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
    mainProgram = "lazygit";
  };
})
