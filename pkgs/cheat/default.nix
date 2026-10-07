{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "cheat";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    tag = finalAttrs.version;
    sha256 = "sha256-0c8NZzzLxssMJffEWBI5L3leWWOU/Y0slPIg6bPKzfI=";
  };

  subPackages = [ "cmd/cheat" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/cheat.1
    installShellCompletion --cmd cheat \
      --bash <($out/bin/cheat --completion bash) \
      --fish <($out/bin/cheat --completion fish) \
      --zsh <($out/bin/cheat --completion zsh)
  '';

  vendorHash = null;

  doCheck = false;

  meta = {
    description = "Create and view interactive cheatsheets on the command-line";
    license = with lib.licenses; [
      gpl3
      mit
    ];
    inherit (finalAttrs.src.meta) homepage;
    mainProgram = "cheat";
  };
})
