{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "trash-cli";
  version = "0.24.5.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = finalAttrs.version;
    hash = "sha256-ltuMnxtG4jTTSZd6ZHWl8wI0oQMMFqW0HAPetZMfGtc=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  build-system = with python3Packages; [
    setuptools
    shtab # for shell completions
  ];

  dependencies = with python3Packages; [
    psutil
    six
  ];

  nativeCheckInputs = with python3Packages; [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    sed -i '/typing/d' setup.cfg
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    # Create a home directory with a test file.
    HOME="$(mktemp -d)"
    touch "$HOME/deleteme"

    # Verify that trash list is initially empty.
    [[ $($out/bin/trash-list) == "" ]]

    # Trash a test file and verify that it shows up in the list.
    $out/bin/trash "$HOME/deleteme"
    [[ $($out/bin/trash-list) == *" $HOME/deleteme" ]]

    # Empty the trash and verify that it is empty.
    $out/bin/trash-empty
    [[ $($out/bin/trash-list) == "" ]]

    runHook postInstallCheck
  '';

  pythonImportsCheck = [ "trashcli" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for bin in trash-empty trash-list trash-restore trash-put trash; do
      installShellCompletion --cmd "$bin" \
        --bash <("$out/bin/$bin" --print-completion bash) \
        --zsh  <("$out/bin/$bin" --print-completion zsh)
    done
  '';
  meta = {
    homepage = "https://github.com/andreafrancia/trash-cli";
    description = "Command line interface to the freedesktop.org trashcan";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    mainProgram = "trash";
  };
})
