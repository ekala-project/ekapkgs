{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "du-dust";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BHlasERvwS/mr6EUfgItvrL/oozFta4/XwwI3hYyMGo=";
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-oIR10K/vn9sexW+m9vOuGJDqXRk2gjB0WoPj71cT+eg=";

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

  meta = {
    description = "du, but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    changelog = "https://github.com/bootandy/dust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "dust";
  };
})
