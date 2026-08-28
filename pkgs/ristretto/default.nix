{
  stdenv,
  lib,
  fetchFromGitLab,
  glib,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  cairo,
  xfce4-exo,
  gtk3,
  libexif,
  libxfce4ui,
  libxfce4util,
  xfconf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ristretto";
  version = "0.14.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "ristretto";
    tag = "ristretto-${finalAttrs.version}";
    hash = "sha256-3Jlm0fqFKOQF9DG1hqc7P2MrILDe/gKkxkT9WPRflBo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib # glib-compile-schemas
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    xfce4-exo
    glib
    gtk3
    libexif
    libxfce4ui
    libxfce4util
    xfconf
  ];

  meta = {
    description = "Fast and lightweight picture-viewer for the Xfce desktop environment";
    homepage = "https://gitlab.xfce.org/apps/ristretto";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ristretto";
    platforms = lib.platforms.linux;
  };
})
