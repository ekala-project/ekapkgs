{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  dbus,
  dbus-glib,
  gstreamer,
  glib,
  gtk3,
  libnotify,
  libx11,
  libxfce4ui,
  libxfce4util,
  taglib,
  xfconf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parole";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "parole";
    tag = "parole-${finalAttrs.version}";
    hash = "sha256-I1wZsuZ/NM5bH6QTJpwd5WL9cIGNtkAxA2j5vhhdaTE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    dbus-glib # dbus-binding-tool
    glib # glib-genmarshal
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    dbus
    dbus-glib
    gstreamer.plugins-bad
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-ugly
    glib
    gtk3
    libnotify
    libx11
    libxfce4ui
    libxfce4util
    taglib
    xfconf
  ];

  meta = {
    description = "Modern simple media player";
    homepage = "https://gitlab.xfce.org/apps/parole";
    license = lib.licenses.gpl2Plus;
    mainProgram = "parole";
    platforms = lib.platforms.linux;
  };
})
