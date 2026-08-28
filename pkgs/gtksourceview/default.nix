{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  atk,
  cairo,
  glib,
  gtk3,
  pango,
  libxml2,
  perl,
  intltool,
  gettext,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtksourceview";
  version = "3.24.11";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${lib.versions.majorMinor finalAttrs.version}/gtksourceview-${finalAttrs.version}.tar.xz";
    sha256 = "1zbpj283b5ycz767hqz5kdq02wzsga65pp4fykvhg8xj6x50f6v9";
  };

  patches = [ ./nix_share_path.patch ];

  nativeBuildInputs = [
    pkg-config
    intltool
    perl
  ];

  buildInputs = [
    atk
    cairo
    glib
    pango
    libxml2
    gettext
  ];

  propagatedBuildInputs = [
    gtk3
    shared-mime-info
  ];

  preBuild = ''
    substituteInPlace gtksourceview/gtksourceview-utils.c --replace "@NIX_SHARE_PATH@" "$out/share"
  '';

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  enableParallelBuilding = true;

  doCheck = false;

  meta = {
    description = "Text editor widget for GTK based on GtkTextView";
    homepage = "https://gitlab.gnome.org/GNOME/gtksourceview";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
  };
})
