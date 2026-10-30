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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-diskperf-plugin";
  version = "2.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-diskperf-plugin";
    tag = "xfce4-diskperf-plugin-${finalAttrs.version}";
    hash = "sha256-UZHr2cNSiRPaPZOfiRGHxiljs0zxe1Bz9h6BbDwYWzk=";
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
    xfconf
  ];

  meta = {
    description = "Disk performance plugin for the Xfce panel";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-diskperf-plugin";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };
})
