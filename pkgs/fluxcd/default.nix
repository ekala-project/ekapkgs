{
  buildGoModule,
  fetchFromGitHub,
  fetchzip,
  installShellFiles,
  lib,
  stdenv,
}:

let
  version = "2.10.1";
  srcHash = "sha256-pVuAZHQZM4vd8Hok8JnSJjCHnHOs03Tn3YLrEWohnLg=";
  vendorHash = "sha256-QyxjzVJi7lvRiorh5LANXhhkBU24uElqY8xOBBrdJco=";
  manifestsHash = "sha256-E8QSOo+IGUb1mV3p/VBBZ7JBXHKrBSzh5BZBjSzKLzc=";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    hash = manifestsHash;
    stripRoot = false;
  };
in

buildGoModule rec {
  pname = "fluxcd";
  inherit vendorHash version;

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    tag = "v${version}";
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
    mainProgram = "flux";
  };
}
