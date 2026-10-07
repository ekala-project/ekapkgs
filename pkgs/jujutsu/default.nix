{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jujutsu";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nqMd9kj6TH/6kTZ8a9XDPBESwCIOMa7c/0TgbEXoo3o=";
  };

  cargoHash = "sha256-rt3mq7+Z+7Z1Y+XUWva+UsrDcVeZs6VjXnhAL0iyP20=";

  nativeBuildInputs = [
    installShellFiles
  ];

  cargoBuildFlags = [
    "--bin"
    "jj"
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = "1";
    LIBGIT2_NO_VENDOR = "1";
    LIBSSH2_SYS_USE_PKG_CONFIG = "1";
  };

  doCheck = false;

  postInstall =
    let
      jj = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/jj";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      mkdir -p $out/share/man
      ${jj} util install-man-pages $out/share/man/

      installShellCompletion --cmd jj \
        --bash <(COMPLETE=bash ${jj}) \
        --fish <(COMPLETE=fish ${jj}) \
        --zsh <(COMPLETE=zsh ${jj})
    '';

  meta = {
    description = "Git-compatible DVCS that is both simple and powerful";
    homepage = "https://jj-vcs.dev/";
    changelog = "https://github.com/jj-vcs/jj/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "jj";
  };
})
