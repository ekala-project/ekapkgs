{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  thunar,
  libxfce4util,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thunar-archive-plugin";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "thunar-plugins";
    repo = "thunar-archive-plugin";
    tag = "thunar-archive-plugin-${finalAttrs.version}";
    hash = "sha256-/WLkEqzFAKpB7z8mWSgufo4Qbj6KP3Ax8MWVZxIwDs0=";
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
    thunar
    glib
    gtk3
    libxfce4util
  ];

  meta = {
    description = "Thunar plugin providing file context menus for archives";
    homepage = "https://gitlab.xfce.org/thunar-plugins/thunar-archive-plugin";
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.linux;
  };
})
