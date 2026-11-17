{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
  rust-jemalloc-sys-unprefixed,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qdrant";
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m4InR9PpMOR3pqumAdBQoC6wFtoWF964qTQJ4/PP1tM=";
  };

  cargoHash = "sha256-gYvZ5l+ZMn8FI9hoZbGo6wRJPFODL0+kaWzW8xefJCQ=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys
    rust-jemalloc-sys-unprefixed
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  # Fix cargo-auditable issue with `bench_rocksdb = ["dep:rocksdb"]`
  auditable = false;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "Vector Search Engine for the next generation of AI applications";
    longDescription = ''
      Expects a config file at config/config.yaml with content similar to
      https://github.com/qdrant/qdrant/blob/master/config/config.yaml
    '';
    homepage = "https://github.com/qdrant/qdrant";
    license = lib.licenses.asl20;
    mainProgram = "qdrant";
  };
})
