{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  go-md2man,
  util-linux,
  btrfs-progs,
  btrfsSupport ? btrfs-progs != null,
  withMan ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

buildGoModule rec {
  pname = "containerd";
  version = "2.1.1";

  outputs = [
    "out"
    "doc"
  ]
  ++ lib.optional withMan "man";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    tag = "v${version}";
    hash = "sha256-ZqQX+bogzAsMvqYNKyWvHF2jdPOIhNQDizKEDbcbmOg=";
  };

  postPatch = "patchShebangs .";

  vendorHash = null;

  strictDeps = true;

  nativeBuildInputs = [
    util-linux
  ]
  ++ lib.optional withMan go-md2man;

  buildInputs = lib.optional btrfsSupport btrfs-progs;

  tags = lib.optional (!btrfsSupport) "no_btrfs";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BUILDTAGS=${toString tags}"
    "REVISION=${src.rev}"
    "VERSION=v${version}"
  ];

  installTargets = [
    "install"
    "install-doc"
  ]
  ++ lib.optional withMan "install-man";

  buildPhase = ''
    runHook preBuild
    make $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make $makeFlags $installTargets
    runHook postInstall
  '';

  meta = {
    description = "Daemon to control runC";
    homepage = "https://containerd.io/";
    changelog = "https://github.com/containerd/containerd/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "containerd";
    platforms = lib.platforms.linux;
  };
}
