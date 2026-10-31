{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtkmm3,
  glibmm_2_4,
  gtksourceview,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtksourceviewmm";
  version = "3.21.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceviewmm/${lib.versions.majorMinor finalAttrs.version}/gtksourceviewmm-${finalAttrs.version}.tar.xz";
    hash = "sha256-mMldzuKHsRGBFWpklSNlC45xejkgJKmmigBGYMSW45s=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    glibmm_2_4
    gtkmm3
    gtksourceview
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gtksourceviewmm";
    description = "C++ wrapper for gtksourceview";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
})
