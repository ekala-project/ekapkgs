{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atuin";
  version = "18.25.1";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fZpe677ju8n3X4Csj7HJDPqcWEFyPE7FL0zVNpiI72g=";
  };

  cargoHash = "sha256-SZKFzRmrz+p2b74SoZgovBoAxPAtL4MjERcv8PTNh5s=";

  # atuin's default features include 'check-updates', which do not make sense
  # for distribution builds. List all other default features.
  buildNoDefaultFeatures = true;

  buildFeatures = [
    "client"
    "sync"
    "clipboard"
    "daemon"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  # Tests reference atuin_server which is not included in the selected features

  meta = {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/atuinsh/atuin";
    license = lib.licenses.mit;
    mainProgram = "atuin";
  };
})
