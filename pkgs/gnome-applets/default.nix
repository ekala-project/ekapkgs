{
  lib,
  stdenv,
  fetchurl,
  gettext,
  itstool,
  libxml2,
  pkg-config,
  # TODO: gnome-panel being ported in ekapkgs (this batch)
  gnome-panel,
  gtk3,
  glib,
  libwnck,
  # TODO: libgtop not yet available in ekapkgs
  libgtop,
  libnotify,
  upower,
  wirelesstools,
  # TODO: linuxPackages (cpupower) not yet available in ekapkgs
  # linuxPackages,
  adwaita-icon-theme,
  # TODO: libgweather being ported to ekapkgs
  libgweather,
  # TODO: gucharmap not yet available in ekapkgs
  gucharmap ? null,
  # TODO: tinysparql being ported to ekapkgs
  tinysparql,
  polkit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-applets";
  version = "3.58.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-applets/${lib.versions.majorMinor finalAttrs.version}/gnome-applets-${finalAttrs.version}.tar.xz";
    hash = "sha256-5h7bcTRNzV2qbnF137snSnWL6LWEUnc1abs1ZFuFojg=";
  };

  nativeBuildInputs = [
    gettext
    glib # glib-compile-resources
    itstool
    pkg-config
    libxml2
  ];

  buildInputs = [
    gnome-panel
    gtk3
    glib
    libxml2
    libwnck
    libgtop
    libnotify
    upower
    adwaita-icon-theme
    libgweather
  ]
  ++ lib.optional (gucharmap != null) gucharmap
  ++ [
    tinysparql
    polkit
    wirelesstools
    # TODO: linuxPackages.cpupower not yet available in ekapkgs
    # linuxPackages.cpupower
  ];

  enableParallelBuilding = true;

  doCheck = true;

  # Don't try to install modules to gnome panel's directory, as it's read only
  env.PKG_CONFIG_LIBGNOME_PANEL_MODULESDIR = "${placeholder "out"}/lib/gnome-panel/modules";

  meta = {
    description = "Applets for use with the GNOME panel";
    mainProgram = "cpufreq-selector";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-applets";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-applets/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
