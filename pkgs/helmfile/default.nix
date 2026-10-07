{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pluginsDir ? null,
}:

buildGoModule (finalAttrs: {
  pname = "helmfile";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-G9gOc7gIj2AoROPRppHqkeGcVUOpYx/qaEVkec4c4rk=";
  };

  vendorHash = "sha256-GBTUYoXCcRD6kZI52VWE46GDlO13ZpxDEYrDd7nRR3s=";

  proxyVendor = true;

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X go.szostok.io/version.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional (pluginsDir != null) makeWrapper;

  postInstall =
    lib.optionalString (pluginsDir != null) ''
      wrapProgram $out/bin/helmfile \
        --set HELM_PLUGINS "${pluginsDir}"
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd helmfile \
        --bash <($out/bin/helmfile completion bash) \
        --fish <($out/bin/helmfile completion fish) \
        --zsh <($out/bin/helmfile completion zsh)
    '';

  meta = {
    description = "Declarative spec for deploying Helm charts";
    mainProgram = "helmfile";
    homepage = "https://helmfile.readthedocs.io/";
    license = lib.licenses.mit;
  };
})
