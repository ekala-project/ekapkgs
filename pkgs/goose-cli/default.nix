{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  cmake,
  openssl,
  libxcb,
  dbus,
  versionCheckHook,
  cacert,
}:

let
  versionData = {
    version = "1.52.0";
    hash = "sha256-JowCy5d/qvYW0a4Nx9DGw4uD2/CQZfCLE0qqoJlJZFA=";
    cargoHash = "sha256-t5TYJgVXQvAxAXE/EaTrogV3YexxmCV35VXncBzrTxk=";
    librustyV8 = {
      version = "145.0.0";
      hashes = {
        x86_64-linux = "sha256-chV1PAx40UH3Ute5k3lLrgfhih39Rm3KqE+mTna6ysE=";
        aarch64-linux = "sha256-4IivYskhUSsMLZY97+g23UtUYh4p5jk7CzhMbMyqXyY=";
        aarch64-darwin = "sha256-yHa1eydVCrfYGgrZANbzgmmf25p7ui1VMas2A7BhG6k=";
      };
    };
  };

  fetchLibrustyV8 = (import ./fetchers.nix { inherit lib stdenv fetchurl; }).fetchLibrustyV8;
  librusty_v8 = import ./librusty_v8.nix {
    inherit fetchLibrustyV8;
    data = versionData.librustyV8;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "goose-cli";
  inherit (versionData) version cargoHash;

  src = fetchFromGitHub {
    owner = "aaif-goose";
    repo = "goose";
    tag = "v${version}";
    inherit (versionData) hash;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    openssl
    libxcb
    dbus
  ];

  nativeCheckInputs = [ cacert ];

  env.RUSTY_V8_ARCHIVE = librusty_v8;

  cargoBuildFlags = [
    "--package"
    "goose-cli"
  ];

  doCheck = true;
  checkPhase = ''
    export HOME=$(mktemp -d)
    export XDG_CONFIG_HOME=$HOME/.config
    export XDG_DATA_HOME=$HOME/.local/share
    export XDG_STATE_HOME=$HOME/.local/state
    export XDG_CACHE_HOME=$HOME/.cache
    mkdir -p $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_STATE_HOME $XDG_CACHE_HOME

    cargo test -p goose-cli -- \
      --skip commands::review::handler::tests::untracked_enumeration_stays_in_opened_root_after_swap
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "CLI for Goose - a local, extensible, open source AI agent that automates engineering tasks";
    homepage = "https://github.com/aaif-goose/goose";
    changelog = "https://github.com/aaif-goose/goose/releases/tag/v${version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "goose";
  };
}
