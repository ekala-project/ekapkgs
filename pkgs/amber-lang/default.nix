{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bc,
  util-linux,
  makeWrapper,
  installShellFiles,
  stdenv,
  bash,
}:

rustPlatform.buildRustPackage rec {
  pname = "amber-lang";
  version = "0.6.0-alpha";

  src = fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber";
    tag = version;
    hash = "sha256-pyMsxb9XPtseroH2MORhMOg9+iaLyoxmgpUTCej+i+Y=";
  };

  cargoHash = "sha256-7TZIRg4NK2uOivUUg09T5mbxrNlRmmVyec2xhmzSNvY=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  nativeCheckInputs = [
    bash
    bc
    util-linux
  ];

  preCheck = ''
    substituteInPlace src/tests/cli.rs \
      --replace-fail 'Command::new(amber_bin())' "Command::new(\"target/${stdenv.targetPlatform.rust.cargoShortTarget}/$cargoBuildType/amber\")"
    substituteInPlace src/tests/cli.rs \
      --replace-fail 'cmd.env("AMBER_SHELL", "/bin/bash")' 'cmd.env("AMBER_SHELL", "bash")'
  '';

  checkFlags = [
    "--skip=tests::extra::download"
    "--skip=tests::stdlib::test_stdlib_src_tests_stdlib_http_fetch_ab"
  ];

  postInstall = ''
    wrapProgram "$out/bin/amber" --prefix PATH : "${lib.makeBinPath [ bc ]}"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd amber \
      --bash <($out/bin/amber completion)
  '';

  meta = {
    description = "Programming language compiled to bash";
    homepage = "https://amber-lang.com";
    license = lib.licenses.lgpl3Only;
    mainProgram = "amber";
    maintainers = [ ];
  };
}
