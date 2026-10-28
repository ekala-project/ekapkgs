{
  lib,
  stdenv,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  libnotify,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-places-plugin";
  version = "1.8.4";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-places-plugin";
    tag = "xfce4-places-plugin-${finalAttrs.version}";
    hash = "sha256-hwdtWz0uoFZdaDxnHpz3AhXU99G/NWKvyZtkeJS32Cc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = {
    description = "Places menu plugin for the Xfce panel";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-places-plugin";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
