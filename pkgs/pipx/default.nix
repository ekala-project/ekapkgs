{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pipx";
  version = "1.16.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "pipx";
    tag = finalAttrs.version;
    hash = "sha256-2su1kJHrSYGnTKCXvWCWRQUMlR0oEhno90D57UIOCJU=";
  };

  build-system = with python3Packages; [
    docutils
    hatchling
    hatch-vcs
  ];

  dependencies = with python3Packages; [
    argcomplete
    colorama
    filelock
    packaging
    platformdirs
    userpath
  ];

  nativeBuildInputs = [
    python3Packages.argcomplete
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd pipx \
      --bash <(register-python-argcomplete pipx --shell bash) \
      --zsh <(register-python-argcomplete pipx --shell zsh) \
      --fish <(register-python-argcomplete pipx --shell fish)
  '';

  doCheck = false;

  pythonImportsCheck = [ "pipx" ];

  meta = {
    description = "Install and run Python applications in isolated environments";
    mainProgram = "pipx";
    homepage = "https://github.com/pypa/pipx";
    changelog = "https://github.com/pypa/pipx/blob/main/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
