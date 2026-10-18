{
  version,
  src-hash,
  mmVariant ? "v2",
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  pango,
  glibmm,
  cairomm,
}:

let
  glibmmPkg = if mmVariant == "v3" then glibmm.v2_68 else glibmm;
  cairommPkg = if mmVariant == "v3" then cairomm.v1_16 else cairomm;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pangomm";
  inherit version;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/pangomm/${lib.versions.majorMinor version}/pangomm-${version}.tar.xz";
    hash = src-hash;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    python3
  ];

  propagatedBuildInputs = [
    pango
    glibmmPkg
    cairommPkg
  ];

  doCheck = true;

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "C++ interface to the Pango text rendering library";
    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';
    homepage = "https://www.pango.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
