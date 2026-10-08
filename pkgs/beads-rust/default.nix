{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

let
  data = {
    version = "0.7.3";
    hash = "sha256-GrVrecYtZmpy3SSdVvGIbk4Tt4xwXcwqarTf4988jKo=";
    cargoHash = "sha256-89SzbNAKLrH63+57TTCcRDded+BlRWpmJE3fBOx+6s4=";
    frankensqlite = {
      rev = "25e8534b4c2a3df807c836454e38f802ac25ac7e";
      hash = "sha256-Z8SoJjnCOPlaBS11f0pPYBCSpVzaGMfbl6TNMhysNBc=";
    };
  };

  # Upstream's tagged Cargo.lock is generated with the dev-local
  # `[patch.crates-io]` config active, so the fsqlite-* entries have no
  # `source` field and are not vendored. Reproduce that environment by placing
  # a sibling frankensqlite checkout and installing the upstream patch table
  # as .cargo/config.toml.
  frankensqlite = fetchFromGitHub {
    owner = "Dicklesworthstone";
    repo = "frankensqlite";
    inherit (data.frankensqlite) rev hash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "beads-rust";
  inherit (data) version cargoHash;

  src = fetchFromGitHub {
    owner = "Dicklesworthstone";
    repo = "beads_rust";
    tag = "v${data.version}";
    inherit (data) hash;
  };

  postUnpack = ''
    cp -r ${frankensqlite} frankensqlite
    chmod -R u+w frankensqlite
  '';

  postPatch = ''
    mkdir -p .cargo
    cp scripts/dev-local-frankensqlite.toml .cargo/config.toml
  '';

  # fsqlite uses #![feature(peer_credentials_unix_socket)] which requires
  # nightly; RUSTC_BOOTSTRAP=1 enables it on stable rustc.
  env.RUSTC_BOOTSTRAP = 1;

  # Disable self_update: not meaningful in Nix.
  buildNoDefaultFeatures = true;

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = data.version;
  };

  meta = {
    description = "Fast Rust port of beads - a local-first issue tracker for git repositories";
    homepage = "https://github.com/Dicklesworthstone/beads_rust";
    changelog = "https://github.com/Dicklesworthstone/beads_rust/releases/tag/v${data.version}";
    downloadPage = "https://github.com/Dicklesworthstone/beads_rust/releases";
    license = lib.licenses.mit;
    mainProgram = "br";
    platforms = lib.platforms.unix;
  };
})
