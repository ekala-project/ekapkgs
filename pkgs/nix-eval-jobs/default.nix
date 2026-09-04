{
  lib,
  boost,
  fetchFromGitHub,
  meson,
  ninja,
  curl,
  nlohmann_json,
  pkg-config,
  stdenv,
  nixVersions,
}:

let
  nixComponents = nixVersions.nixComponents_2_35;
in

stdenv.mkDerivation rec {
  pname = "nix-eval-jobs";
  version = "2.35.2";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nix-eval-jobs";
    tag = "v${version}";
    hash = "sha256-qHxk1wVKqz/UMtVC14ugkhySbqYcRQbwobyeO/fhAf0=";
  };

  buildInputs = [
    boost
    curl
    nlohmann_json
    nixComponents.nix-store
    nixComponents.nix-fetchers
    nixComponents.nix-expr
    nixComponents.nix-flake
    nixComponents.nix-main
    nixComponents.nix-cmd
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
  ];

  passthru = {
    inherit nixComponents;
    nix = nixComponents.nix-cli;
  };

  meta = {
    description = "Hydra's builtin hydra-eval-jobs as a standalone";
    homepage = "https://github.com/NixOS/nix-eval-jobs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "nix-eval-jobs";
  };
}
