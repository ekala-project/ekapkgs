{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lsd";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lsd-rs";
    repo = "lsd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BDwptBRGy2IGc3FrgFZ1rt/e1bpKs1Y0C3H4JfqRqHc=";
  };

  cargoHash = "sha256-TcC8ZY8Xv0076bLrprXGPh5nyGnR2NRnGeuTSEK4+Gg=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd lsd \
      --bash $releaseDir/build/lsd-*/out/lsd.bash \
      --fish $releaseDir/build/lsd-*/out/lsd.fish \
      --zsh $releaseDir/build/lsd-*/out/_lsd
  '';

  nativeCheckInputs = [ git ];

  meta = {
    homepage = "https://github.com/lsd-rs/lsd";
    description = "Next gen ls command";
    license = lib.licenses.asl20;
    mainProgram = "lsd";
  };
})
