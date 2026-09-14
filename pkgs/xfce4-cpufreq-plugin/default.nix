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
  pname = "xfce4-cpufreq-plugin";
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-cpufreq-plugin";
    tag = "xfce4-cpufreq-plugin-${finalAttrs.version}";
    hash = "sha256-IJ0gOzMs2JBS8KIlD5NHyUOf53PtTytm8J/j+5AEh5E=";
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
    description = "CPU Freq load plugin for Xfce panel";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-cpufreq-plugin";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
