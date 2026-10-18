{
  version,
  src-hash,
  sigcxxVariant ? "v2",
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  m4,
  glib,
  libsigcxx,
  libsigcxx30,
  meson,
  ninja,
}:

let
  sigcxx = if sigcxxVariant == "v3" then libsigcxx30 else libsigcxx;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "glibmm";
  inherit version;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${lib.versions.majorMinor version}/glibmm-${version}.tar.xz";
    hash = src-hash;
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
    m4
    glib # for glib-compile-schemas
  ];

  propagatedBuildInputs = [
    glib
    sigcxx
  ];

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "C++ interface to the GLib library";
    homepage = "https://gtkmm.org/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
