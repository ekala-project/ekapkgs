{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  libxfce4util,
  libxfce4ui,
  gtk3,
  glib,
  libmpd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfmpc";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfmpc";
    tag = "xfmpc-${finalAttrs.version}";
    hash = "sha256-fYK8JbWFnkzFpgfmSHa6usnlke4G7pxmdSm7kEQsL5M=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    libxfce4ui
    libxfce4util
  ];

  buildInputs = [
    gtk3
    glib
    libmpd
    libxfce4ui
    libxfce4util
  ];

  meta = {
    description = "MPD client written in GTK for Xfce";
    homepage = "https://docs.xfce.org/apps/xfmpc/start";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "xfmpc";
  };
})
