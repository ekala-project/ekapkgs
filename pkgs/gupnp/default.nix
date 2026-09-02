{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  gssdp,
  libsoup_3,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gupnp";
  version = "1.6.10";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${lib.versions.majorMinor finalAttrs.version}/gupnp-${finalAttrs.version}.tar.xz";
    hash = "sha256-oe4Ht7Emc8Mtf8c8oVilDBpNxpqzW2XpTSTTish1NF4=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    glib
    gssdp
    libsoup_3
    libxml2
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dintrospection=false"
    "-Dvapi=false"
  ];

  doCheck = true;

  meta = {
    homepage = "http://www.gupnp.org/";
    description = "Implementation of the UPnP specification";
    mainProgram = "gupnp-binding-tool-1.6";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
