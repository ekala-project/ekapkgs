{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  gettext,
  gnutls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glib-networking";
  version = "2.80.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glib-networking/${lib.versions.majorMinor finalAttrs.version}/glib-networking-${finalAttrs.version}.tar.xz";
    hash = "sha256-uA4odBV81VBx8bZxD6C5EdWsXeEGqe4qTJx77mF4L44=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    glib
  ];

  buildInputs = [
    glib
    gnutls
  ];

  mesonBuildType = "release";

  mesonFlags = [
    "-Dlibproxy=disabled"
    "-Dgnome_proxy=disabled"
    "-Denvironment_proxy=enabled"
    "-Dinstalled_tests=false"
  ];

  doCheck = false;

  meta = {
    description = "Network-related giomodules for glib";
    homepage = "https://gitlab.gnome.org/GNOME/glib-networking";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
