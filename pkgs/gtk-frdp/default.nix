{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gobject-introspection,
  glib,
  gtk3,
  freerdp,
  fuse3,
}:

stdenv.mkDerivation {
  pname = "gtk-frdp";
  version = "0-unstable-2026-04-24";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gtk-frdp";
    rev = "05919e9958b655252a0e5572c215fc9aee0aa863";
    hash = "sha256-SGSHsuv/XOLfjESRk9B2GV64zvrG8xGoaBoHO6EeAZw=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    freerdp
    fuse3
  ];

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gtk-frdp";
    description = "RDP viewer widget for GTK";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
}
