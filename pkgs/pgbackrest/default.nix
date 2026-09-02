{
  bzip2,
  fetchFromGitHub,
  lib,
  libbacktrace,
  libpq,
  libssh2,
  libxml2,
  libyaml,
  lz4,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv,
  systemd,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgbackrest";
  version = "2.59.1";

  src = fetchFromGitHub {
    owner = "pgbackrest";
    repo = "pgbackrest";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-bCHjIQ0WIlvjGg1b4jNwWKzxLg+YIDswKx/Jt6EwAdQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    bzip2
    libbacktrace
    libpq
    libssh2
    libxml2
    libyaml
    lz4
    systemd
    zlib
    zstd
  ];
  meta = {
    description = "Reliable PostgreSQL backup & restore";
    homepage = "https://pgbackrest.org";
    changelog = "https://github.com/pgbackrest/pgbackrest/releases/tag/release%2F${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "pgbackrest";
  };
})
