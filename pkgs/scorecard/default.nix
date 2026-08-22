{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
}:

buildGo126Module (finalAttrs: {
  pname = "scorecard";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "ossf";
    repo = "scorecard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RfOunjr4QeMFlMHkOOhHB8vb5XDNLNEmdDe9KSL/kP8=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-hzOGN6l7cxP+m4UWtrHV0Oihx3QIwZ09WR/Vi2HGwIg=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${finalAttrs.version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  preBuild = ''
    ldflags+=" -X sigs.k8s.io/release-utils/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X sigs.k8s.io/release-utils/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  nativeCheckInputs = [ gitMinimal ];

  preCheck = ''
    getGoDirs() {
      go list ./... | grep -v e2e
    }
    export SKIP_GINKGO=1
  '';

  checkFlags = [
    "-skip TestCollectDockerfilePinning/Non-pinned_dockerfile|TestMixedPinning"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd scorecard \
      --bash <($out/bin/scorecard completion bash) \
      --fish <($out/bin/scorecard completion fish) \
      --zsh <($out/bin/scorecard completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/scorecard --help
    $out/bin/scorecard version 2>&1 | grep "v${finalAttrs.version}"
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/ossf/scorecard";
    changelog = "https://github.com/ossf/scorecard/releases/tag/v${finalAttrs.version}";
    description = "Security health metrics for Open Source";
    mainProgram = "scorecard";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
