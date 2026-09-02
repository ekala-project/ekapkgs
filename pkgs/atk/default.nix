{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  makeWrapper,
  python3,
  dbus,
  glib,
  libx11,
  libxml2,
  libxtst,
  libxi,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "at-spi2-core";
  version = "2.60.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/at-spi2-core/${lib.versions.majorMinor finalAttrs.version}/at-spi2-core-${finalAttrs.version}.tar.xz";
    hash = "sha256-Gh9bqYBZF/QfxqpoI9z4h6KR1gekJ+LVr7a136ZQcMc=";
  };

  nativeBuildInputs = [
    glib
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    makeWrapper
    python3
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    libx11
    libxml2
    libxtst
    libxi
    libxext
  ];

  propagatedBuildInputs = [
    dbus
    glib
  ];

  doCheck = false;

  mesonFlags = [
    "-Ddbus_daemon=/run/current-system/sw/bin/dbus-daemon"
    "-Duse_systemd=false"
  ]
  ++ lib.optionals (!withIntrospection) [
    (lib.mesonEnable "introspection" false)
  ];

  meta = {
    description = "Assistive Technology Service Provider Interface protocol definitions and daemon for D-Bus";
    homepage = "https://gitlab.gnome.org/GNOME/at-spi2-core";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
