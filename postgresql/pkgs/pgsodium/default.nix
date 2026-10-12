{
  bash,
  fetchFromGitHub,
  lib,
  libsodium,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgsodium";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "michelp";
    repo = "pgsodium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y8xL3PxF1GQV1JIgolMI1e8oGcUvWAgrPv84om7wKP8=";
  };

  buildInputs = [
    bash # required for patchShebangs
    libsodium
  ];

  postInstall = ''
    install -D -t $out/share/pgsodium/getkey_scripts getkey_scripts/*
    ln -s $out/share/pgsodium/getkey_scripts/pgsodium_getkey_urandom.sh $out/share/postgresql/extension/pgsodium_getkey
  '';

  meta = {
    description = "Modern cryptography for PostgreSQL using libsodium";
    homepage = "https://github.com/michelp/pgsodium";
    changelog = "https://github.com/michelp/pgsodium/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
  };
})
