{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  which,
  libvirt,
  makeWrapper,
  writableTmpDirAsHomeHook,
  OVMF ? null,
  withQemu ? false,
  qemu ? null,
}:

buildGoModule (finalAttrs: {
  pname = "minikube";
  version = "1.39.0";

  vendorHash = "sha256-9WtBgb1nBGuETWUZZsgJ4G+vN0MNDpZWk/S1+nVPwbE=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I/ZbbsX9BSTAEuBJ65iJ5vtoKxvNuxLY/FSXld1jBuc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "export GOTOOLCHAIN := go\$(GO_VERSION)" "export GOTOOLCHAIN := local"
  ''
  + lib.optionalString (withQemu && OVMF != null) ''
    substituteInPlace \
      pkg/minikube/registry/drvs/qemu2/qemu2.go \
      --replace-fail "/usr/share/OVMF/OVMF_CODE.fd" "${OVMF.firmware}" \
      --replace-fail "/usr/share/AAVMF/AAVMF_CODE.fd" "${OVMF.firmware}"
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    which
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  buildInputs = [ libvirt ];

  buildPhase = ''
    runHook preBuild

    make COMMIT=${finalAttrs.src.rev}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    installBin out/minikube

    wrapProgram $out/bin/minikube \
      --set MINIKUBE_WANTUPDATENOTIFICATION false \
      --prefix PATH : ${lib.makeBinPath (lib.optionals withQemu [ qemu ] ++ [ libvirt ])}
    ln -sv $out/bin/minikube $out/bin/kubectl

    installShellCompletion --cmd minikube \
      --bash <($out/bin/minikube completion bash) \
      --fish <($out/bin/minikube completion fish) \
      --zsh <($out/bin/minikube completion zsh)

    runHook postInstall
  '';

  meta = {
    homepage = "https://minikube.sigs.k8s.io";
    description = "Tool that makes it easy to run Kubernetes locally";
    mainProgram = "minikube";
    license = lib.licenses.asl20;
  };
})
