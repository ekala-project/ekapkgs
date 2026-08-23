{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  buildGo126Module,
  buildPackages,
  gpgme,
  btrfs-progs ? null,
  libapparmor ? null,
  libseccomp ? null,
  libselinux ? null,
  systemd ? null,
  makeBinaryWrapper,
  python3,
  go-md2man ? buildPackages.go-md2man,
}:

buildGo126Module (finalAttrs: {
  pname = "podman";
  version = "5.8.4";

  src = fetchFromGitHub {
    owner = "podman-container-tools";
    repo = "podman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zhEtMZVKiv1L72EMlwgz8sHpmvhejGp98oW63aPj+rQ=";
  };

  patches = [
    ./rm-podman-mac-helper-msg.patch
  ];

  vendorHash = null;

  doCheck = false;

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeBinaryWrapper
    python3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux (
    lib.filter (x: x != null) [
      btrfs-progs
      gpgme
      libapparmor
      libseccomp
      libselinux
      systemd
    ]
  );

  env = {
    PREFIX = "${placeholder "out"}";
    GOMD2MAN = "${go-md2man}/bin/go-md2man";
  };

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make bin/podman bin/rootlessport bin/quadlet
    make docs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install.bin install.systemd
    make install.completions install.man
    runHook postInstall
  '';

  postFixup = lib.optionalString (stdenv.hostPlatform.isLinux && systemd != null) ''
    RPATH=$(patchelf --print-rpath $out/bin/podman)
    patchelf --set-rpath "${lib.makeLibraryPath [ systemd ]}":$RPATH $out/bin/podman
  '';

  meta = {
    homepage = "https://podman.io/";
    description = "Program for managing pods, containers and container images";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "podman";
    platforms = lib.platforms.unix;
  };
})
