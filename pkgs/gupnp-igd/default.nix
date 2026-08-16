{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gettext,
  glib,
  gupnp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gupnp-igd";
  version = "1.6.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-igd/${lib.versions.majorMinor finalAttrs.version}/gupnp-igd-${finalAttrs.version}.tar.xz";
    hash = "sha256-QJmXgzmrIhJtSWjyozK20JT8RMeHl4YHgfH8LxF3G3Q=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gettext
  ];

  propagatedBuildInputs = [
    glib
    gupnp
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dintrospection=false"
  ];

  meta = {
    description = "Library to handle UPnP IGD port mapping";
    homepage = "http://www.gupnp.org/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
