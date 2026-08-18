{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  buildPackages,
  installShellFiles,
  makeWrapper,
  enableCmount ? false,
  fuse3 ? null,
}:

buildGoModule (finalAttrs: {
  pname = "rclone";
  version = "1.75.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rclone";
    repo = "rclone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Al3jB+R8U68TuIfDQ+q9V/OjIed176csajwiSljwZU=";
  };

  vendorHash = "sha256-jjbDyZwHCx9oeFuMVMY5sJeRNlCUyU9quO/aqzxeJnU=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = lib.optional (enableCmount && fuse3 != null) fuse3;

  tags = lib.optionals (fuse3 != null) [ "fuse3" ] ++ lib.optionals enableCmount [ "cmount" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/rclone/rclone/fs.Version=${finalAttrs.src.tag}"
  ];

  postConfigure = lib.optionalString (fuse3 != null) ''
    substituteInPlace vendor/github.com/winfsp/cgofuse/fuse/host_cgo.go \
        --replace-fail "fuse.h" "fuse3/fuse.h"
  '';

  postInstall =
    let
      rcloneBin =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out"
        else
          lib.getBin buildPackages.rclone;
    in
    ''
      installManPage rclone.1
      for shell in bash zsh fish; do
        ${rcloneBin}/bin/rclone genautocomplete $shell rclone.$shell
        installShellCompletion rclone.$shell
      done

      # filesystem helpers
      ln -s $out/bin/rclone $out/bin/rclonefs
      ln -s $out/bin/rclone $out/bin/mount.rclone
    ''
    + lib.optionalString (enableCmount && fuse3 != null) ''
      wrapProgram $out/bin/rclone \
        --suffix PATH : "${lib.makeBinPath [ fuse3 ]}"
    '';

  meta = {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = "https://rclone.org";
    changelog = "https://github.com/rclone/rclone/blob/v${finalAttrs.version}/docs/content/changelog.md";
    license = lib.licenses.mit;
    mainProgram = "rclone";
    maintainers = [ ];
  };
})
