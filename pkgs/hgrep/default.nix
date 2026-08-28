{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  version = "0.3.9";
in
rustPlatform.buildRustPackage {
  pname = "hgrep";
  inherit version;

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "hgrep";
    tag = "v${version}";
    hash = "sha256-xBLpEs0PvYb7sIca9yb3vhi2Bsr1BFqB0jlD+bZT2EI=";
  };

  cargoHash = "sha256-TP+PClv7FX3kRBwJ0RAKbKoTKpi7hTZgw/Z/ktFKbwQ=";

  meta = {
    description = "Grep with human-friendly search results";
    homepage = "https://github.com/rhysd/hgrep";
    license = lib.licenses.mit;
    mainProgram = "hgrep";
  };
}
