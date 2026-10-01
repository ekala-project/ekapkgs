{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  gettext,
  pkg-config,
  networkmanager,
  adwaita-icon-theme,
  libsecret,
  polkit,
  modemmanager,
  libnma,
  glib-networking,
  gsettings-desktop-schemas,
  libgudev,
  jansson,
  wrapGAppsHook3,
  gobject-introspection,
  python3,
  gtk3,
  libayatana-appindicator,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "network-manager-applet";
  version = "1.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/network-manager-applet/${lib.versions.majorMinor finalAttrs.version}/network-manager-applet-${finalAttrs.version}.tar.xz";
    hash = "sha256-qEcESH6jr+FIXEf7KrWYuPd59UCuDcvwocX4XmSn4lM=";
  };

  mesonFlags = [
    "-Dselinux=false"
    "-Dappindicator=yes"
  ];

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    gettext
    pkg-config
    wrapGAppsHook3
    gobject-introspection
    python3
  ];

  buildInputs = [
    libnma
    gtk3
    networkmanager
    libsecret
    gsettings-desktop-schemas
    polkit
    libgudev
    modemmanager
    jansson
    glib
    glib-networking
    libayatana-appindicator
    adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = {
    description = "NetworkManager control applet for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/network-manager-applet/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "nm-applet";
    platforms = lib.platforms.linux;
  };
})
