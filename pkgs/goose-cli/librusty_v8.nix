# Pre-built librusty_v8 library for goose-cli.
# Version and per-platform hashes live in hashes.json (librustyV8 key) and are
# kept in sync with goose's Cargo.lock by update.py.
{ fetchLibrustyV8 }:

let
  data = (builtins.fromJSON (builtins.readFile ./hashes.json)).librustyV8;
in
fetchLibrustyV8 {
  inherit (data) version;
  shas = data.hashes;
}
