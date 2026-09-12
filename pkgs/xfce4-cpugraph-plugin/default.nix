{
  stdenv,
  lib,
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
  pname = "xfce4-cpugraph-plugin";
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-cpugraph-plugin";
    tag = "xfce4-cpugraph-plugin-${finalAttrs.version}";
    hash = "sha256-IXAoxMzKZhABiiZYhL4UGkzqFNGMJicGQqSIfy2DEfc=";
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
    description = "CPU graph show for Xfce panel";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-cpugraph-plugin";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
