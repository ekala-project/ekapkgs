# Pre-built librusty_v8 library for goose-cli.
{ fetchLibrustyV8, data }:

fetchLibrustyV8 {
  inherit (data) version;
  shas = data.hashes;
}
