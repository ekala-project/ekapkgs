{
  stdenv,
  lib,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  systemd,
  liburing,
  zstd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plocate";
  version = "1.1.24";

  src = fetchgit {
    url = "https://git.sesse.net/plocate";
    rev = finalAttrs.version;
    sha256 = "sha256-VvHptw/PG2uWflTmGNCj1PXIguXv9Bikz8qj2hRMnaQ=";
  };

  postPatch = ''
    sed -i meson.build \
      -e '/mkdir\.sh/d'
  '';

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    systemd
    liburing
    zstd
  ];

  mesonEntries = {
    systemunitdir = "${placeholder "out"}/etc/systemd/system";
    sharedstatedir = "/var/cache";
    dbpath = "locatedb";
  };

  meta = {
    description = "Much faster locate";
    homepage = "https://plocate.sesse.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
