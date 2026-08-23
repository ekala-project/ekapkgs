{
  lib,
  stdenv,
  fetchurl,
  appstream,
  gettext,
  libgtop,
  gtk4,
  libadwaita,
  pango,
  pcre2,
  vte-gtk4 ? null,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-console";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-console/${lib.versions.major finalAttrs.version}/gnome-console-${finalAttrs.version}.tar.xz";
    hash = "sha256-5JUCB/BUfmpsDxjuv89uGhBGHqsPL64KrlErEETHrG4=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libgtop
    gtk4
    libadwaita
    pango
    pcre2
    vte-gtk4
  ];

  preFixup = ''
    gappsWrapperArgs+=(--set "TERM" "xterm-256color")
  '';

  meta = {
    description = "Simple user-friendly terminal emulator for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/GNOME/console";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "kgx";
  };
})
