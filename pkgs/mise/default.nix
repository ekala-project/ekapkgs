{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mise";
  version = "2026.10.2";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZMrPP9GcEW8r7Txn5+FLByH98qBOkU3C/csC5vLQIN8=";
  };

  cargoHash = "sha256-MV1vSGthpVHznFVUBjkRgxfj1r6HAZZF8XVDyjIlGt0=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  # disable warnings as errors for aws-lc-sys in checkPhase
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  # Many tests require network access or specific env setup
  doCheck = false;

  postInstall = ''
    installManPage ./man/man1/mise.1

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise

    mkdir -p $out/lib/mise
    touch $out/lib/mise/.disable-self-update
  '';

  meta = {
    homepage = "https://mise.jdx.dev";
    description = "Front-end to your dev env";
    changelog = "https://github.com/jdx/mise/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mise";
  };
})
