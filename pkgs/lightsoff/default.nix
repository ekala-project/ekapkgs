{
  lib,
  stdenv,
  fetchurl,
  vala,
  pkg-config,
  glib,
  gtk4,
  libadwaita,
  gdk-pixbuf,
  gettext,
  itstool,
  libxml2,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lightsoff";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${lib.versions.major finalAttrs.version}/lightsoff-${finalAttrs.version}.tar.xz";
    hash = "sha256-uqDBdDHoXu7eXmSfUxYvcLTrHnx6bxak7KowJ7ZTFXg=";
  };

  nativeBuildInputs = [
    vala
    pkg-config
    gtk4.wrapGAppsHook
    itstool
    gettext
    libxml2
    meson
    meson.configurePhaseHook
    ninja
    python3
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
    substituteInPlace build-aux/meson_post_install.py \
      --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/lightsoff";
    changelog = "https://gitlab.gnome.org/GNOME/lightsoff/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Puzzle game, where the objective is to turn off all of the tiles on the board";
    mainProgram = "lightsoff";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
