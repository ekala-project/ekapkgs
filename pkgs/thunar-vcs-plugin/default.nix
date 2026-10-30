{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  thunar,
  xfce4-exo,
  libxfce4ui,
  libxfce4util,
  gtk3,
  glib,
  subversion,
  apr,
  aprutil,

  withSubversion ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thunar-vcs-plugin";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "thunar-plugins";
    repo = "thunar-vcs-plugin";
    tag = "thunar-vcs-plugin-${finalAttrs.version}";
    hash = "sha256-VuTTao46/3JNzCHv7phCC8DCy9rjlEcMuGmGiIOSsMM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    thunar
    xfce4-exo
    libxfce4ui
    libxfce4util
    gtk3
    glib
  ]
  ++ lib.optionals withSubversion [
    apr
    aprutil
    subversion
  ];

  mesonFeatures = {
    svn = withSubversion;
  };

  meta = {
    description = "Thunar plugin providing support for Subversion and Git";
    homepage = "https://gitlab.xfce.org/thunar-plugins/thunar-vcs-plugin";
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.linux;
  };
})
