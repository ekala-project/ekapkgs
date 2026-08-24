{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  which,
  makeWrapper,
  rsync,
  installShellFiles,
  runtimeShell,
  kubectl ? null,

  components ? [
    "cmd/kubeadm"
    "cmd/kubelet"
    "cmd/kube-apiserver"
    "cmd/kube-controller-manager"
    "cmd/kube-proxy"
    "cmd/kube-scheduler"
  ],
}:

buildGo126Module (finalAttrs: {
  pname = "kubernetes";
  version = "1.36.4";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cOrTskng+TTesoC2Ss6H7tGjW6e3fm/eKQUewJZeL6o=";
  };

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    which
    rsync
    installShellFiles
  ];

  outputs = [
    "out"
    "man"
    "pause"
  ];

  patches = [ ./fixup-addonmanager-lib-path.patch ];

  env.WHAT = toString components;

  buildPhase = ''
    runHook preBuild
    substituteInPlace "hack/update-generated-docs.sh" --replace "make" "make SHELL=${runtimeShell}"
    patchShebangs ./hack ./cluster/addons/addon-manager
    make "SHELL=${runtimeShell}" "WHAT=$WHAT"
    ./hack/update-generated-docs.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    for p in $WHAT; do
      install -D _output/local/go/bin/''${p##*/} -t $out/bin
    done

    cc build/pause/linux/pause.c -o pause
    install -D pause -t $pause/bin

    rm docs/man/man1/kubectl*
    installManPage docs/man/man1/*.[1-9]

    ${lib.optionalString (kubectl != null) ''
      ln -s ${kubectl}/bin/kubectl $out/bin/kubectl
    ''}

    substitute cluster/addons/addon-manager/kube-addons-main.sh $out/bin/kube-addons \
      --subst-var out

    chmod +x $out/bin/kube-addons
    wrapProgram $out/bin/kube-addons --set "KUBECTL_BIN" "$out/bin/kubectl"

    cp cluster/addons/addon-manager/kube-addons.sh $out/bin/kube-addons-lib.sh

    installShellCompletion --cmd kubeadm \
      --bash <($out/bin/kubeadm completion bash) \
      --zsh <($out/bin/kubeadm completion zsh)
    runHook postInstall
  '';

  meta = {
    description = "Production-Grade Container Scheduling and Management";
    license = lib.licenses.asl20;
    homepage = "https://kubernetes.io";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
