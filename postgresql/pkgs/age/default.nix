{
  bison,
  fetchFromGitHub,
  flex,
  lib,
  perl,
  postgresql,
  postgresqlBuildExtension,
}:

let
  hashes = {
    # PostgreSQL 18 support tracked at apache/age#2164.
    "17" = "sha256-gqoAhVqQaDhe5CIcTc//1HonQLP1zoBIGuCQuXsJy+A=";
    "16" = "sha256-iukdi2c3CukGvjuTojybFFAZBlAw8GEfzFPr2qJuwTA=";
    "15" = "sha256-webZWgWZGnSoXwTpk816tjbtHV1UIlXkogpBDAEL4gM=";
    "14" = "sha256-jZXhcYBubpjIJ8M5JHXKV5f6VK/2BkypH3P7nLxZz3E=";
    "13" = "sha256-HR6nnWt/V2a0rD5eHHUsFIZ1y7lmvLz36URt9pPJnCw=";
  };
in
postgresqlBuildExtension (finalAttrs: {
  pname = "age";
  version = if lib.versionAtLeast postgresql.version "16" then "1.6.0-rc0" else "1.5.0-rc0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "age";
    tag = "PG${lib.versions.major postgresql.version}/v${finalAttrs.version}";
    hash =
      hashes.${lib.versions.major postgresql.version}
      or (throw "Source for AGE is not available for ${postgresql.version}");
  };

  makeFlags = [
    "BISON=${bison}/bin/bison"
    "FLEX=${flex}/bin/flex"
    "PERL=${perl}/bin/perl"
  ];

  enableUpdateScript = false;

  meta = {
    broken = !builtins.elem (lib.versions.major postgresql.version) (builtins.attrNames hashes);
    description = "Graph database extension for PostgreSQL";
    homepage = "https://age.apache.org/";
    changelog = "https://github.com/apache/age/raw/PG${lib.versions.major postgresql.version}/v${finalAttrs.version}/RELEASE";
    license = lib.licenses.asl20;
    platforms = postgresql.meta.platforms;
  };
})
