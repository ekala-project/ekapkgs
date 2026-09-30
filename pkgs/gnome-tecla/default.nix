{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk4,
  libadwaita,
  libxkbcommon,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tecla";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/tecla/${lib.versions.major finalAttrs.version}/tecla-${finalAttrs.version}.tar.xz";
    hash = "sha256-JUKsskhQCC4Mz2qhevllHbcdIvDiM/2/XtDP/i5FvAY=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libxkbcommon
    wayland
  ];

  meta = {
    description = "Keyboard layout viewer";
    homepage = "https://gitlab.gnome.org/GNOME/tecla";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "tecla";
  };
})
