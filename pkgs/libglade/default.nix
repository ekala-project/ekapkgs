{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  libxml2,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libglade";
  version = "2.6.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libglade/${lib.versions.majorMinor finalAttrs.version}/libglade-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ZDYedkeDnTbtgzbZkv0hDT6BOYgiab7UfcRnSYAWXew=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    gtk2
    libxml2
  ];

  meta = {
    description = "Library for loading Glade interface files at runtime";
    homepage = "https://gitlab.gnome.org/Archive/libglade";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
