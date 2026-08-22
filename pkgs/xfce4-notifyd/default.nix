{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  dbus,
  glib,
  gtk3,
  gtk-layer-shell,
  libcanberra ? null,
  libnotify,
  libx11,
  libxfce4ui,
  libxfce4util,
  sqlite,
  systemd,
  xfce4-panel,
  xfconf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-notifyd";
  version = "0.9.7";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-notifyd";
    tag = "xfce4-notifyd-${finalAttrs.version}";
    hash = "sha256-pgdoy3mZOGMOBwK/cYEl8fre4fZo2lfyWzZnrSYlQ64=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    glib # glib-genmarshal
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  mesonFlags = [
    (lib.mesonOption "sound" "disabled")
  ];

  buildInputs = [
    dbus
    gtk3
    gtk-layer-shell
    glib
    libnotify
    libx11
    libxfce4ui
    libxfce4util
    sqlite
    systemd
    xfce4-panel
    xfconf
  ];

  meta = {
    description = "Simple notification daemon for Xfce";
    homepage = "https://gitlab.xfce.org/apps/xfce4-notifyd";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-notifyd-config";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
