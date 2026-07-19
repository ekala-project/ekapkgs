{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  udev,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgudev";
  version = "238";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libgudev/${lib.versions.majorMinor finalAttrs.version}/libgudev-${finalAttrs.version}.tar.xz";
    hash = "sha256-YSZqsa/J1z28YKiyr3PpnS/f9H2ZVE0IV2Dk+mZ7XdE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    glib
  ];

  buildInputs = [
    udev
    glib
  ];

  doCheck = false;

  mesonFlags = [
    (lib.mesonEnable "introspection" false)
    (lib.mesonEnable "vapi" false)
    (lib.mesonEnable "tests" false)
  ];

  meta = {
    description = "Library that provides GObject bindings for libudev";
    homepage = "https://gitlab.gnome.org/GNOME/libgudev";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
