{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
  makeWrapper,
}:

buildGo126Module (finalAttrs: {
  pname = "git-town";
  version = "24.0.0";

  src = fetchFromGitHub {
    owner = "git-town";
    repo = "git-town";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Es2FextJFPV3SVIIuZOv7EjUHwFar3C5wBMlWlhMu1M=";
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
    maintainers = [ ];
    mainProgram = "git-town";
  };
})
