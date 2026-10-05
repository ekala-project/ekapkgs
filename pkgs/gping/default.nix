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
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    tag = "gping-v${finalAttrs.version}";
    hash = "sha256-+oJzm7lEYS3K+GlYMfSxO2qkUb3AXy04e1YVflar9yI=";
  };

  cargoHash = "sha256-6tAHfcXTMorob0wjdWNxKJ7wAZrwGZqH2hgX9AzN3Yc=";

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
    mainProgram = "gping";
  };
})
