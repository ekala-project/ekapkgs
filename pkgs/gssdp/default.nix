{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  libsoup_3,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gssdp";
  version = "1.6.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor finalAttrs.version}/gssdp-${finalAttrs.version}.tar.xz";
    hash = "sha256-dn0idSVM4O/q6sZEGf+fTwrUcNE072cvXFVrKrt4a8s=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    libsoup_3
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonEntries = {
    gtk_doc = false;
    sniffer = false;
    manpages = false;
    introspection = false;
    vapi = false;
  };

  doCheck = true;

  meta = {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = "http://www.gupnp.org/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
  };
})
