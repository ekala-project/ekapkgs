{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taskwarrior-tui";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8Gpf8D7XocdcHuJKLqfT1QeqkIa7cQHEAoTkKIl/RrU=";
  };

  cargoHash = "sha256-u0W1qVj0SRYVtnoWMqxeuBC9QvibogL4quiQLxzM8LM=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = ''
    installShellCompletion completions/taskwarrior-tui.{bash,fish} --zsh completions/_taskwarrior-tui
  '';

  meta = {
    description = "Terminal user interface for taskwarrior";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = lib.licenses.mit;
    mainProgram = "taskwarrior-tui";
  };
})
