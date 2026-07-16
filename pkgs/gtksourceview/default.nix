{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  meson,
  ninja,
  pkg-config,
  atk,
  cairo,
  glib,
  gtk3,
  pango,
  fribidi,
  libxml2,
  perl,
  gettext,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtksourceview";
  version = "4.8.4";

  outputs = [
    "out"
    "dev"
  ];

  src =
    let
      inherit (finalAttrs) pname version;
    in
    fetchurl {
      url = "mirror://gnome/sources/gtksourceview/${lib.versions.majorMinor version}/gtksourceview-${version}.tar.xz";
      sha256 = "fsnRj7KD0fhKOj7/O3pysJoQycAGWXs/uru1lYQgqH0=";
    };

  patches = [
    ./4.x-nix_share_path.patch

    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gtksourceview/-/commit/685b3bd08869c2aefe33fad696a7f5f2dc831016.patch";
      hash = "sha256-yeYXJ2l/QS857C4UXOnMFyh0JsptA0TQt0lfD7wN5ic=";
    })

    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gtksourceview/-/commit/1dbbb01da98140e0b2d5d0c6c2df29247650ed83.patch";
      hash = "sha256-6HxLKQyI5DDvmKhmldQlwVPV62RfFa2gwWbcHA2cICs=";
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    perl
  ];

  mesonFlags = [
    "-Dgir=false"
    "-Dvapi=false"
  ];

  buildInputs = [
    atk
    cairo
    glib
    pango
    fribidi
    libxml2
  ];

  propagatedBuildInputs = [
    gtk3
    shared-mime-info
  ];

  doCheck = false;

  meta = {
    description = "Source code editing widget for GTK";
    homepage = "https://gitlab.gnome.org/GNOME/gtksourceview";
    pkgConfigModules = [ "gtksourceview-4" ];
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
})
