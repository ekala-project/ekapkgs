{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "sqlc";
  version = "1.31.1";

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/skb7p3s9TaQE699UCprk1D6S+G/T8Ek9/ADOtS/n44=";
  };

  proxyVendor = true;
  vendorHash = "sha256-+kSAupLQwTzJdgnhlqulEtRcDj9gqSq8uTnWNyDLZew=";

  subPackages = [ "cmd/sqlc" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sqlc \
      --bash <($out/bin/sqlc completion bash) \
      --fish <($out/bin/sqlc completion fish) \
      --zsh <($out/bin/sqlc completion zsh)
  '';
  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    mainProgram = "sqlc";
  };
})
