{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "kind";
  version = "0.32.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "kubernetes-sigs";
    repo = "kind";
    hash = "sha256-ii0VhS1Nib+r2ZFIIkRvkcGY1fLxev6WnhbqvaZW7j8=";
  };

  patches = [
    ./kernel-module-path.patch

    (fetchpatch {
      url = "https://github.com/kubernetes-sigs/kind/commit/9a24e6c1ae3d59f8de052ee5c3842820450a369a.patch";
      hash = "sha256-BP2Ub8b1GA7V0CGvhcoGuHRm7u+IMRTmN3mDc2rePnY=";
    })
  ];

  vendorHash = "sha256-tRpylYpEGF6XqtBl7ESYlXKEEAt+Jws4x4VlUVW8SNI=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kind \
      --bash <($out/bin/kind completion bash) \
      --fish <($out/bin/kind completion fish) \
      --zsh <($out/bin/kind completion zsh)
  '';

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage = "https://github.com/kubernetes-sigs/kind";
    maintainers = [ ];
    license = lib.licenses.asl20;
    mainProgram = "kind";
  };
})
