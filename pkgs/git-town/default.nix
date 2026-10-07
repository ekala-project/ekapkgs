{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "git-town";
  version = "24.1.0";

  src = fetchFromGitHub {
    owner = "git-town";
    repo = "git-town";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GY/aec9agBahpTUtss+1/PCab4CJSFGd9hG3dSZLWXw=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags =
    let
      modulePath = "github.com/git-town/git-town/v${lib.versions.major finalAttrs.version}";
    in
    [
      "-s"
      "-w"
      "-X ${modulePath}/src/cmd.version=v${finalAttrs.version}"
      "-X ${modulePath}/src/cmd.buildDate=nix"
    ];

  doCheck = false;

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd git-town \
        --bash <($out/bin/git-town completions bash) \
        --fish <($out/bin/git-town completions fish) \
        --zsh <($out/bin/git-town completions zsh)
    ''
    + ''
      wrapProgram $out/bin/git-town --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
    '';

  meta = {
    description = "Generic, high-level git support for git-flow workflows";
    homepage = "https://www.git-town.com/";
    license = lib.licenses.mit;
    mainProgram = "git-town";
  };
})
