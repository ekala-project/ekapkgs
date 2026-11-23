{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sccache";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-PD4BZ9V3qfcpAqn7f80KdOGIsKwJVwZcK5HlFXfcrrI=";
  };

  cargoHash = "sha256-aWKgnxyqwXs0m2hC+5Da8hdn93WC7ZK85vi5bQk5qB8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Tests fail because of client server setup which is not possible inside the
  # pure environment, see https://github.com/mozilla/sccache/issues/460

  meta = {
    description = "Ccache with Cloud Storage";
    mainProgram = "sccache";
    homepage = "https://github.com/mozilla/sccache";
    changelog = "https://github.com/mozilla/sccache/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
  };
})
