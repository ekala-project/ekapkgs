{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miniserve";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ae2Y51GuFjC65n2JYIPB1D029Zfhy7OvgZeQy+Syzqw=";
  };

  cargoHash = "sha256-KwkmkbQ1E2LJeif7iQmb7pFjZtXhu7BU+YutGb5UmY4=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ openssl ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/miniserve --print-manpage >miniserve.1
    installManPage miniserve.1

    installShellCompletion --cmd miniserve \
      --bash <($out/bin/miniserve --print-completions bash) \
      --fish <($out/bin/miniserve --print-completions fish) \
      --zsh <($out/bin/miniserve --print-completions zsh)
  '';

  meta = {
    description = "CLI tool to serve files and directories over HTTP";
    homepage = "https://github.com/svenstaro/miniserve";
    changelog = "https://github.com/svenstaro/miniserve/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "miniserve";
  };
})
