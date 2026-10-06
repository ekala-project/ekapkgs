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
  versionData = builtins.fromJSON (builtins.readFile ./hashes.json);

  fetchLibrustyV8 = (import ./fetchers.nix { inherit lib stdenv fetchurl; }).fetchLibrustyV8;
  librusty_v8 = import ./librusty_v8.nix { inherit fetchLibrustyV8; };
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
