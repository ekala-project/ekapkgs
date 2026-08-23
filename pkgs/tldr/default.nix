{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tldr";
  version = "3.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tldr-python-client";
    tag = finalAttrs.version;
    hash = "sha256-xFRpw6H4xriuwHWAGeWks/vJOzpW3+AEH/QZ0uPYtiI=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    termcolor
    shtab
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_error_message"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tldr \
      --bash <($out/bin/tldr --print-completion bash | sed -E "s#\"/nix/store/[^\"]+/bin/python[^\"]*\" -m tldr#\"$out/bin/tldr\"#g") \
      --zsh <($out/bin/tldr --print-completion zsh | sed -E "s#\"/nix/store/[^\"]+/bin/python[^\"]*\" -m tldr#\"$out/bin/tldr\"#g")
  '';

  meta = {
    description = "Simplified and community-driven man pages";
    homepage = "https://tldr.sh";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tldr";
  };
})
