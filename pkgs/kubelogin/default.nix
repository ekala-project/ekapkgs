{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGo126Module,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "kubelogin";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "kubelogin";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Gmbrcnr0kyJaUK1ubutBqxYe4WgyCM/cCYcTLpGQECQ=";
  };

  vendorHash = "sha256-/oJRl4s8XN8xPwE5VTLZ3XKuUQYgz1tMsL9zPgjgVFs=";

  subPackages = [ "." ];

  ldflags = [
    "-X main.gitTag=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/kubelogin completion bash >kubelogin.bash
    $out/bin/kubelogin completion fish >kubelogin.fish
    $out/bin/kubelogin completion zsh >kubelogin.zsh
    installShellCompletion kubelogin.{bash,fish,zsh}
  '';

  meta = {
    description = "Kubernetes credential plugin implementing Azure authentication";
    mainProgram = "kubelogin";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
  };
})
