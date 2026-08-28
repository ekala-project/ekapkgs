{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pueue";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = "pueue";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6/Q0+ME1wwHZI5MwMULzS+2iWK2R3JiTM5I+spSjd30=";
  };

  cargoHash = "sha256-l2i57DU8NVg7DtQqOkS/DDBJpfn7NSkgI5Wik+sKhfM=";

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
