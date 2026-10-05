{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "chezmoi";
  version = "2.73.0";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AqwWZExlbPCSUM5kwzfkf/+dNVC5CRNwUK3flpbrjJw=";
  };

  vendorHash = "sha256-/y93llHXz/pSA0BgOTmT8s83RR/EJb/wzFqguEEuy/Q=";

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.builtBy=nixpkgs"
  ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --bash --name chezmoi.bash completions/chezmoi-completion.bash
    installShellCompletion --fish completions/chezmoi.fish
    installShellCompletion --zsh completions/chezmoi.zsh
  '';
  meta = {
    description = "Manage your dotfiles across multiple machines, securely";
    homepage = "https://www.chezmoi.io/";
    changelog = "https://github.com/twpayne/chezmoi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "chezmoi";
  };
})
