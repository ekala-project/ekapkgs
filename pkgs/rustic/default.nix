{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  tzdata,
  fuse,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustic";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EAY6w4XzUPEEn1kutgk962WeNI1LIT3dkRp+GD+wyuo=";
  };

  cargoHash = "sha256-UBOQfkQDjdunTJKu4ORXA979FvfKb3Raz6UQK9WMQ58=";

  buildFeatures = lib.optionals stdenv.hostPlatform.isLinux [ "mount" ];

  checkFeatures = lib.subtractLists [ "mount" ] finalAttrs.buildFeatures; # we do not want `mount` during unit tests because it breaks rustic's test snapshots

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ fuse ];

  nativeCheckInputs = [ tzdata ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rustic \
      --bash <($out/bin/rustic completions bash) \
      --fish <($out/bin/rustic completions fish) \
      --zsh <($out/bin/rustic completions zsh)
  '';

  # We set TZDIR to avoid this warning during unit tests:
  # > [WARN] could not find zoneinfo, concatenated tzdata or bundled time zone database
  # This warning causes the check phase to fail.
  preCheck = ''
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  meta = {
    homepage = "https://github.com/rustic-rs/rustic";
    changelog = "https://github.com/rustic-rs/rustic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Fast, encrypted, deduplicated backups powered by pure Rust";
    mainProgram = "rustic";
    platforms = lib.platforms.all;
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
  };
})
