{
  buildGo126Module,
  fetchFromGitHub,
  fetchzip,
  installShellFiles,
  lib,
  stdenv,
}:

let
  version = "2.9.3";
  srcHash = "sha256-xu+9Ks+Jrzxk+D2GUmw68/mprNf8ynQZiCmMNpVkR4M=";
  vendorHash = "sha256-h5APVAwqyodfaoNq5SqHF/3Vu3O2XfdlZ9O/apA49pc=";
  manifestsHash = "sha256-L1dSNLFKtAGS7A+vvz7t68YifOxWoFxPTmNB31iaGoo=";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    hash = manifestsHash;
    stripRoot = false;
  };
in

buildGo126Module rec {
  pname = "fluxcd";
  inherit vendorHash version;

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    hash = srcHash;
  };

  postUnpack = ''
    cp -r ${manifests} $sourceRoot/cmd/flux/manifests

    # disable tests that require network access
    rm $sourceRoot/cmd/flux/create_secret_git_test.go
  '';

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  subPackages = [ "cmd/flux" ];

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/flux --version | grep ${version} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd flux \
        --$shell <($out/bin/flux completion $shell)
    done
  '';

  meta = {
    changelog = "https://github.com/fluxcd/flux2/releases/tag/v${version}";
    description = "Open and extensible continuous delivery solution for Kubernetes";
    homepage = "https://fluxcd.io";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "flux";
  };
}
