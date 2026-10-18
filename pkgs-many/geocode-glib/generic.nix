{
  version,
  src-hash,
  soupVariant ? "v1",
  mkVariantPassthru,
  ...
}@variantArgs:

{
  stdenv,
  lib,
  fetchurl,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gettext,
  gtk-doc,
  docbook-xsl-nons,
  gobject-introspection,
  libsoup,
  libsoup_3,
  json-glib,
  glib,
}:

let
  useSoup3 = soupVariant == "v2";
  soupPkg = if useSoup3 then libsoup_3 else libsoup;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "geocode-glib";
  inherit version;

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals useSoup3 [
    "devdoc"
    "installedTests"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${lib.versions.majorMinor version}/geocode-glib-${version}.tar.xz";
    sha256 = src-hash;
  };

  patches = lib.optionals useSoup3 [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    gtk-doc
    docbook-xsl-nons
    gobject-introspection
  ]
  ++ lib.optionals (useSoup3 && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    soupPkg
    json-glib
  ];

  mesonEntries = {
    soup2 = false;
  } // lib.optionalAttrs useSoup3 {
    installed_test_prefix = "${placeholder "installedTests"}";
  } // lib.optionalAttrs (!useSoup3) {
    enable-installed-tests = false;
    enable-introspection = false;
    enable-gtk-doc = false;
  };

  passthru = mkVariantPassthru variantArgs;

  meta = {
    changelog = "https://gitlab.gnome.org/GNOME/geocode-glib/-/blob/${version}/NEWS?ref_type=tags";
    description = "Convenience library for the geocoding and reverse geocoding using Nominatim service";
    homepage = "https://gitlab.gnome.org/GNOME/geocode-glib";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
