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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-wavelan-plugin";
  version = "0.6.4";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-wavelan-plugin";
    tag = "xfce4-wavelan-plugin-${finalAttrs.version}";
    hash = "sha256-tZHSV5G7IjR83Muui8YHep+FutWqmmUrU9EmzOjrgUM=";
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
    libxfce4ui
    libxfce4util
    xfce4-panel
  ];

  meta = {
    description = "Wireless LAN plugin for the Xfce panel";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-wavelan-plugin";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };
})
