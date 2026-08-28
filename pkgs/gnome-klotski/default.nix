{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  vala,
  adwaita-icon-theme,
  gtk3,
  wrapGAppsHook3,
  appstream-glib,
  desktop-file-utils,
  glib,
  librsvg,
  # TODO: libxml2 not yet available
  gettext,
  itstool,
  libgee,
  libgnome-games-support,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-klotski";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-klotski/${lib.versions.majorMinor finalAttrs.version}/gnome-klotski-${finalAttrs.version}.tar.xz";
    hash = "sha256-kWN4RWSfPKcJ0p9x7ndblG0REghyCfMiZOj60hoMoOI=";
  };

  nativeBuildInputs = [
    pkg-config
    vala
    meson
    ninja
    python3
    wrapGAppsHook3
    gettext
    itstool
    # TODO: libxml2 not yet available
    appstream-glib
    desktop-file-utils
    adwaita-icon-theme
  ];

  buildInputs = [
    glib
    gtk3
    librsvg
    libgee
    libgnome-games-support
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-klotski";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-klotski/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Slide blocks to solve the puzzle";
    mainProgram = "gnome-klotski";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
