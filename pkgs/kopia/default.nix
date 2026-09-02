{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGo126Module (finalAttrs: {
  pname = "kopia";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "kopia";
    repo = "kopia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yjeLV7N/U88oVdP4iJYgSM/QJLAMREaB/2jBcbTDWkA=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-5p/MUNkqNb+iAFxXXYRR2NB1WiGVIcNrTADsd/VjapU=";

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/kopia/kopia/repo.BuildVersion=${finalAttrs.version}"
    "-X github.com/kopia/kopia/repo.BuildInfo=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    substituteInPlace internal/mount/mount_posix_webdav_helper_linux.go \
      --replace-fail "/usr/bin/mount" "mount" \
      --replace-fail "/usr/bin/umount" "umount"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kopia \
      --bash <($out/bin/kopia --completion-script-bash) \
      --zsh <($out/bin/kopia --completion-script-zsh)
  '';

  meta = {
    homepage = "https://kopia.io";
    changelog = "https://github.com/kopia/kopia/releases/tag/v${finalAttrs.version}";
    description = "Cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication";
    mainProgram = "kopia";
    license = lib.licenses.asl20;
  };
})
