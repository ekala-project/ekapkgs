{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
  libxkbcommon, # TODO: not in ekapkgs, needs porting or corepkgs
  wayland, # TODO: not in ekapkgs, needs porting or corepkgs
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
    ninja
    pkg-config
    wrapGAppsHook4
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
    maintainers = [ ];
  };
})
