{
  lib,
  rustPlatform,
  fetchFromGitea,
  openssl,
  pkg-config,
  protobuf,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "garage";
  version = "1.3.1";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wkCnJmbulnhzwHvzdpzh9MRceOzmPdhOogffwhqNGPg=";
  };

  cargoHash = "sha256-jfYe2A6zkVgTLrWBDbahICSKCRO3FwsBPNSVFapH0Rs=";

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [ openssl ];

  checkInputs = [ cacert ];

  env.OPENSSL_NO_VENDOR = true;

  # Keep in sync with
  # https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v${finalAttrs.version}/nix/compile.nix
  buildFeatures = [
    "bundled-libs"
    "consul-discovery"
    "fjall"
    "journald"
    "k2v"
    "kubernetes-discovery"
    "lmdb"
    "metrics"
    "sqlite"
    "syslog"
    "telemetry-otlp"
  ];

  meta = {
    description = "S3-compatible object store for small self-hosted geo-distributed deployments";
    changelog = "https://git.deuxfleurs.fr/Deuxfleurs/garage/releases/tag/v${finalAttrs.version}";
    homepage = "https://garagehq.deuxfleurs.fr";
    license = lib.licenses.agpl3Only;
    mainProgram = "garage";
  };
})
