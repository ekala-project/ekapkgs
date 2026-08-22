{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wrapGAppsHook3,
  glib,
  gtk3,
  libx11,
  libxtst,
  libxfce4ui,
  libxfce4util,
  qrencode,
  xfce4-panel,
  xfconf,
  wayland,
  wlr-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-clipman-plugin";
  version = "1.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-clipman-plugin";
    tag = "xfce4-clipman-plugin-${finalAttrs.version}";
    hash = "sha256-w9axHJJnTQrkN9s3RQyvkOcK0FOqsvWpoJ+UCDntnZk=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libx11
    libxtst
    libxfce4ui
    libxfce4util
    qrencode
    xfce4-panel
    xfconf
    wayland
    wlr-protocols
  ];

  meta = {
    description = "Clipboard manager for Xfce panel";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-clipman-plugin";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
