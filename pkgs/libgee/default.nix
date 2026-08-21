{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  vala,
  pkg-config,
  glib,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgee";
  version = "0.20.8";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libgee/${lib.versions.majorMinor finalAttrs.version}/libgee-${finalAttrs.version}.tar.xz";
    sha256 = "GJgVrBQ9iYZxk7DFK33DHzqhCKFfBNa13KK2rfrQsO4=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
  ];

  doCheck = true;

  env = {
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "dev"}/share/gir-1.0";
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";
  }
  // lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  }
  // lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  meta = {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    homepage = "https://gitlab.gnome.org/GNOME/libgee";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
