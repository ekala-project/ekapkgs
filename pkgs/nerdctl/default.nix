{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  buildkit ? null,
  cni-plugins ? null,
  extraPackages ? [ ],
}:

buildGoModule (finalAttrs: {
  pname = "nerdctl";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "nerdctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zsYVV34ud1yegNm67Aq+rBNb4C0tjToHOuCVGyr2Pjo=";
  };

  vendorHash = "sha256-MI+SpB9xFWMOQES5rL3nwLbFctwsvkyy7yoyxRCHc7M=";

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

      export HOME=$(mktemp -d)
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
    platforms = lib.platforms.linux;
  };
})
