{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  gpgme,
  lvm2,
  btrfs-progs,
  pkg-config,
  go-md2man,
  installShellFiles,
  makeWrapper,
  fuse-overlayfs,
  runCommand,
}:

buildGo126Module rec {
  pname = "skopeo";
  version = "1.24.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "podman-container-tools";
    repo = "skopeo";
    hash = "sha256-RAK6fGy6qCHuJogUeWNoUVOccS7IfRJRozYVrcftQhU=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    go-md2man
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    gpgme
    lvm2
    btrfs-progs
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make bin/skopeo docs
    make completions
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=${placeholder "out"} make install-binary install-docs
    PREFIX=${placeholder "out"} make install-completions
    install ${passthru.policy}/default-policy.json -Dt $out/etc/containers
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs ]}
    runHook postInstall
  '';

  passthru = {
    policy = runCommand "policy" { } ''
      install ${src}/default-policy.json -Dt $out
    '';
  };

  meta = {
    changelog = "https://github.com/podman-container-tools/skopeo/releases/tag/${src.rev}";
    description = "Command line utility for various operations on container images and image repositories";
    mainProgram = "skopeo";
    homepage = "https://github.com/podman-container-tools/skopeo";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
}
