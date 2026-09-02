{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  # TODO: dconf not yet ported to ekapkgs
  dconf,
  # TODO: evolution-data-server being ported to ekapkgs
  evolution-data-server,
  # TODO: gdm may need review
  gdm,
  geocode-glib_2,
  gettext,
  glib,
  gnome-desktop,
  gnome-menus,
  gtk3,
  itstool,
  # TODO: libgweather being ported to ekapkgs
  libgweather,
  libwnck,
  libxml2,
  pkg-config,
  polkit,
  # TODO: systemd not yet ported to ekapkgs
  # systemd,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-panel";
  version = "3.58.1";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-panel/${lib.versions.majorMinor finalAttrs.version}/gnome-panel-${finalAttrs.version}.tar.xz";
    hash = "sha256-fovKQ6gaE0xmazp4uvKv+wxdMO+xvKZTiH/EGzHdXmQ=";
  };

  patches = [
    # Load modules from path in `NIX_GNOME_PANEL_MODULESDIR` environment variable
    # instead of gnome-panel's libdir so that the NixOS module can make gnome-panel
    # load modules from other packages as well.
    ./modulesdir-env-var.patch
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome-menus}/share"
      --prefix XDG_CONFIG_DIRS : "${gnome-menus}/etc/xdg"
    )
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    itstool
    libxml2
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dconf
    evolution-data-server
    gdm
    geocode-glib_2
    glib
    gnome-desktop
    gnome-menus
    gtk3
    libgweather
    libwnck
    polkit
    # TODO: systemd not yet ported to ekapkgs
    # systemd
  ];

  configureFlags = [
    "--enable-eds"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Component of Gnome Flashback that provides panels and default applets for the desktop";
    mainProgram = "gnome-panel";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-panel";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-panel/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
