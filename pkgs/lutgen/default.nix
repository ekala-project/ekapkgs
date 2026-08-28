{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lutgen";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    tag = "lutgen-v${finalAttrs.version}";
    hash = "sha256-8sayt1gLJPdhesUvSoykUYjIiGLRJH5avsRSrWLfIVE=";
  };

  cargoHash = "sha256-CJXobmGOFEOiycrtgKjupVwTCYLMQcEI7RdLGpwmSyg=";

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "--bin"
    "lutgen"
  ];

  cargoTestFlags = [
    "-p"
    "lutgen-cli"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lutgen \
      --bash <($out/bin/lutgen --bpaf-complete-style-bash) \
      --fish <($out/bin/lutgen --bpaf-complete-style-fish) \
      --zsh <($out/bin/lutgen --bpaf-complete-style-zsh)
  '';

  meta = {
    description = "Blazingly fast interpolated LUT generator and applicator for arbitrary and popular color palettes";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    mainProgram = "lutgen";
    license = lib.licenses.mit;
  };
})
