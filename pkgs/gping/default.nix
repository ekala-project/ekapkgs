{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  iputils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gping";
  version = "1.20.4";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    tag = "gping-v${finalAttrs.version}";
    hash = "sha256-m26GtfRhgib13g+3/cXLwIdMKr3CofaMKFFCFKa8OI4=";
  };

  cargoHash = "sha256-CFJ7X0hJG6Whd9vMHo5Au93LueXiAHHEo9dPOKSmD+k=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ iputils ];

  postInstall = ''
    installManPage gping.1
  '';

  checkFlags = [
    "--skip=test::tests::test_integration_any"
    "--skip=test::tests::test_integration_ip6"
    "--skip=test::tests::test_integration_ipv4"
  ];

  meta = {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    changelog = "https://github.com/orf/gping/releases/tag/gping-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gping";
  };
})
