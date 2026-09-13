{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  libepoxy,
  glib,
  gtk3,
  libpulseaudio,
  libsamplerate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "retro-gtk";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/retro-gtk/${lib.versions.majorMinor finalAttrs.version}/retro-gtk-${finalAttrs.version}.tar.xz";
    sha256 = "1lnb7dwcj3lrrvdzd85dxwrlid28xf4qdbrgfjyg1wn1z6sv063i";
  };

  patches = [
    ./gio-unix.patch
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/retro-gtk/-/commit/8016c10e7216394bc66281f2d9be740140b6fad6.patch";
      sha256 = "sha256-HcQnqadK5sJM5mMqi4KERkJM3H+MUl8AJAorpFDsJ68=";
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  # Disable introspection/vapi: Gtk-3.0.gir not available in ekapkgs (corepkgs issue)
  mesonFlags = [
    "-Dintrospection=false"
    "-Dvapi=false"
  ];

  buildInputs = [
    libepoxy
    glib
    gtk3
    libpulseaudio
    libsamplerate
  ];

  meta = {
    description = "GTK Libretro frontend framework";
    mainProgram = "retro-demo";
    homepage = "https://gitlab.gnome.org/GNOME/retro-gtk";
    changelog = "https://gitlab.gnome.org/GNOME/retro-gtk/-/blob/master/NEWS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
