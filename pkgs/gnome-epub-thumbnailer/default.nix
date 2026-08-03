{
  stdenv,
  lib,
  fetchurl,
  wrapGAppsNoGuiHook,
  meson,
  ninja,
  pkg-config,
  gnome,
  gdk-pixbuf,
  glib,
  libarchive,
  librsvg,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-epub-thumbnailer";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-epub-thumbnailer/${lib.versions.majorMinor finalAttrs.version}/gnome-epub-thumbnailer-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-+QYZ1YxpkC8u/1e58AQrRzeGEIP0dZIaMQ/sxhL8oBc=";
  };

  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    libarchive
    librsvg
    libxml2
  ];
  meta = {
    description = "Thumbnailer for EPub and MOBI books";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-epub-thumbnailer";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
