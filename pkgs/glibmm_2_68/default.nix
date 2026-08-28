{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnum4,
  glib,
  libsigcxx30,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glibmm";
  version = "2.88.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${lib.versions.majorMinor finalAttrs.version}/glibmm-${finalAttrs.version}.tar.xz";
    hash = "sha256-plSdo6bEPeg7hxfa5UE8V6YNkvbsxiRhXGEtC7CtD+I=";
  };

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
    libsigcxx30
  ];

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  meta = {
    description = "C++ interface to the GLib library";
    homepage = "https://gtkmm.org/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
