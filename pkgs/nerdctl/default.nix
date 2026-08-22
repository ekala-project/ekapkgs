{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  buildkit ? null,
  cni-plugins ? null,
  extraPackages ? [ ],
}:

buildGo126Module (finalAttrs: {
  pname = "nerdctl";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "nerdctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4t6yyoFnYm5rGNw8SG1nfy5C0+nks/9G8pzhuZ4U0ag=";
  };

  vendorHash = "sha256-hjqtwOph1grdmR2kHIbBVCxuNxNnUHPH8RJSCXo0rvU=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  ldflags =
    let
      t = "github.com/containerd/nerdctl/v${lib.versions.major finalAttrs.version}/pkg/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=v${finalAttrs.version}"
      "-X ${t}.Revision=<unknown>"
    ];

  excludedPackages = [ "mod/tigron" ];

  doCheck = false;

  postInstall =
    let
      runtimePath = lib.makeBinPath (lib.optional (buildkit != null) buildkit ++ extraPackages);
      cniPath = lib.optionalString (cni-plugins != null) "${cni-plugins}/bin";
    in
    ''
      wrapProgram $out/bin/nerdctl \
        ${lib.optionalString (runtimePath != "") "--prefix PATH : \"${runtimePath}\""} \
        ${lib.optionalString (cniPath != "") "--prefix CNI_PATH : \"${cniPath}\""}

      installShellCompletion --cmd nerdctl \
        --bash <($out/bin/nerdctl completion bash) \
        --fish <($out/bin/nerdctl completion fish) \
        --zsh <($out/bin/nerdctl completion zsh)
    '';

  meta = {
    homepage = "https://github.com/containerd/nerdctl/";
    changelog = "https://github.com/containerd/nerdctl/releases/tag/v${finalAttrs.version}";
    description = "Docker-compatible CLI for containerd";
    mainProgram = "nerdctl";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
