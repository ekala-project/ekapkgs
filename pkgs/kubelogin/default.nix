{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubelogin";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "kubelogin";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-cizq2jWhv75fAetk58XaHphAk3nwMkicaX4PFkFdx5s=";
  };

  vendorHash = "sha256-S5seDNIrtjt+MOJ2C8tVCEWy7FpDP8qjb9MTFMrkEJ0=";

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
