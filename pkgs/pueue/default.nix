{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pueue";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = "pueue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xK0s3MT1hrDqAtVIgwM3tQb/yWD1mbgkZ4fJ3TxyEi4=";
  };

  cargoHash = "sha256-aKDz1PiIh3w+q70ukVKMkcbygM3cM6hVExwhSlf5lOw=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rustPlatform.bindgenHook
  ];

  checkFlags = [
    "--test client_tests"
    "--skip=test_single_huge_payload"
    "--skip=test_create_unix_socket"
  ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/pueue completions $shell .
    done
    installShellCompletion pueue.{bash,fish} _pueue
  '';

  meta = {
    homepage = "https://github.com/Nukesor/pueue";
    description = "Daemon for managing long running shell commands";
    changelog = "https://github.com/Nukesor/pueue/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
})
