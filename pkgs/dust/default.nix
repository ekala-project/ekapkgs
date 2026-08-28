{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "du-dust";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-80UcDIXnRvpmIcpDGwrMo9KGgPVafuUOIBIozDHctTo=";
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-dXlyoBYsgnyKvoNh60uR1itDB/fqzIQtZ1R/gv28CMY=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [
    "--skip=test_show_files_by_type"
  ];

  preCheck = ''
    rm tests/test_exact_output.rs
    rm tests/tests_symlinks.rs
  '';

  postInstall = ''
    installManPage man-page/dust.1
    installShellCompletion completions/dust.{bash,fish} --zsh completions/_dust
  '';

  doInstallCheck = true;

  meta = {
    description = "du, but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    changelog = "https://github.com/bootandy/dust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "dust";
  };
})
