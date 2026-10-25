{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnum4 ? m4,
  m4,
  glib,
  libsigcxx_2_0,
  gnome,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glibmm";
  version = "2.66.8";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${lib.versions.majorMinor finalAttrs.version}/glibmm-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZPEdO5WiTiqNQWbs/1GHMPeezCciLvQfr3x+A0D8kyk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
    gnum4
    glib # for glib-compile-schemas
  ];
  propagatedBuildInputs = [
    glib
    libsigcxx_2_0
  ];

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  meta = {
    description = "C++ interface to the GLib library";

    homepage = "https://gtkmm.org/";

    license = lib.licenses.lgpl2Plus;

    platforms = lib.platforms.unix;
  };
})
