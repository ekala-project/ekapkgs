{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "procs";
  version = "0.14.12";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "procs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FvBxBleOGWkjV+3uydSESYXybOYrwnBgXwacGftu7Ec=";
  };

  cargoHash = "sha256-e+ShskUeBIe0PWyzqxAv+XRoEbDyh45SUM4WL3CsiD4=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    for shell in bash fish zsh; do
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/procs --gen-completion $shell
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  meta = {
    description = "Modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "procs";
  };
})
