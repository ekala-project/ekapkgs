{
  lib,
  stdenv,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  libxfce4util,
  xfce4-panel,
  libxfce4ui,
  glib,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-fsguard-plugin";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-fsguard-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-fsguard-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-nkDPPOezThwn1rRC86BniGw1FUtdDE1kSiOQOGEdpk8=";
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
    libxfce4util
    libxfce4ui
    xfce4-panel
    glib
    gtk3
  ];

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-fsguard-plugin";
    description = "Filesystem usage monitor plugin for the Xfce panel";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };
})
