{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fclones";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = "fclones";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OCRfJh6vfAkL86J1GuLgfs57from3fx0NS1Bh1+/oXE=";
  };

  cargoHash = "sha256-aEjsBhm0iPysA1Wz1Ea7rtX0g/yH/rklUkYV/Elxcq8=";

  nativeBuildInputs = [ installShellFiles ];

  # device::test_physical_device_name test fails on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # ofborg sometimes fails with "Resource temporarily unavailable"
    "--skip=cache::test::return_none_if_different_transform_was_used"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # setting PATH required so completion script doesn't use full path
    export PATH="$PATH:$out/bin"
    installShellCompletion --cmd $pname \
      --bash <(fclones complete bash) \
      --fish <(fclones complete fish) \
      --zsh <(fclones complete zsh)
  '';
  versionCheckProgramArg = "--version";
  meta = {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    changelog = "https://github.com/pkolaczk/fclones/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "fclones";
  };
})
