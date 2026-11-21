{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "fabric-ai";
  version = "1.4.578";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X+5xdI9cg5qxjYJAu7H7rv5Zfmx/2j/Z8r8TR6W1zDw=";
  };

  vendorHash = "sha256-xOX7fpvJxVvcfgWYRhA93FyXhT2lSsPLB+/MryMqv00=";

  # Fabric introduced plugin tests that fail in the nix build sandbox.

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      --bash ./completions/fabric.bash \
      --zsh ./completions/_fabric \
      --fish ./completions/fabric.fish
  '';

  meta = {
    description = "Fabric is an open-source framework for augmenting humans using AI. It provides a modular framework for solving specific problems using a crowdsourced set of AI prompts that can be used anywhere";
    homepage = "https://github.com/danielmiessler/fabric";
    license = lib.licenses.mit;
    mainProgram = "fabric";
  };
})
