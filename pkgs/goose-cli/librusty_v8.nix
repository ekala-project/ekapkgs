# Pre-built librusty_v8 library for goose-cli.
# The version and per-platform hashes are supplied by the caller (from the
# inline `versionData.librustyV8`) and kept in sync with goose's Cargo.lock.
{ fetchLibrustyV8, data }:

fetchLibrustyV8 {
  inherit (data) version;
  shas = data.hashes;
}
