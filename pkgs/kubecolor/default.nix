{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  kubectl ? null,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubecolor";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kubecolor";
    repo = "kubecolor";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ePjiWDvNWZ3RnB5Lz3K7BhWCnlsz458Nj1KauYze55I=";
  };

  vendorHash = "sha256-z3I5XP/ZebZeSSM/+dzJvPG1OK7fFW2vVYPHLhhG1xo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "."
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    lib.optionalString (kubectl != null && stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      ''
        installShellCompletion --cmd kubecolor \
          --bash <(${lib.getExe kubectl} completion bash) \
          --fish <(${lib.getExe kubectl} completion fish) \
          --zsh <(${lib.getExe kubectl} completion zsh)

        echo 'complete -o default -F __start_kubectl kubecolor' >> $out/share/bash-completion/completions/kubecolor.bash
        echo -e 'function kubecolor --wraps kubectl\n  command kubecolor $argv\nend' >> $out/share/fish/vendor_completions.d/kubecolor.fish
        echo 'compdef kubecolor=kubectl' >> $out/share/zsh/site-functions/_kubecolor
      '';

  meta = {
    description = "Colorizes kubectl output";
    mainProgram = "kubecolor";
    homepage = "https://github.com/kubecolor/kubecolor";
    changelog = "https://github.com/kubecolor/kubecolor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
