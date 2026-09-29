{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook_xsl,
  glib,
  libxslt,
  meson,
  ninja,
  pkg-config,
  xfce4-exo,
  gstreamer,
  gtk3,
  libburn,
  libgudev,
  libisofs,
  libxfce4ui,
  libxfce4util,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfburn";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfburn";
    tag = "xfburn-${finalAttrs.version}";
    hash = "sha256-10MjUxy1Ul6CVLdEWFnjppgsI4fAUWqkT2azJBzp0/Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    docbook_xsl
    glib # glib-genmarshal
    libxslt # xsltproc
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    xfce4-exo
    glib
    gstreamer
    gstreamer.plugins-base
    gtk3
    libburn
    libgudev
    libisofs
    libxfce4ui
    libxfce4util
  ];

  meta = {
    description = "Disc burner and project creator for Xfce";
    homepage = "https://gitlab.xfce.org/apps/xfburn";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfburn";
    platforms = lib.platforms.linux;
  };
})
