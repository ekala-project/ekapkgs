{
  stdenv,
  lib,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
  libx11,
  libxext,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  libnotify,
  lm_sensors,
  linuxPackages ? null,

  nvidiaSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-sensors-plugin";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-sensors-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-sensors-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-hARCuH/d3NhZW9n4Pqi4H3cf4pa7nSq/Dhl54ghyeuk=";
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
    glib
    gtk3
    libx11
    libxext
    libxfce4ui
    libxfce4util
    xfce4-panel
    libnotify
    lm_sensors
  ]
  ++ lib.optionals nvidiaSupport [ linuxPackages.nvidia_x11.settings.libXNVCtrl ];

  mesonFeatures = {
    xnvctrl = nvidiaSupport;
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-sensors-plugin";
    description = "Panel plug-in for different sensors using acpi, lm_sensors and hddtemp";
    mainProgram = "xfce4-sensors";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
