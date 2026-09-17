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

stdenv.mkDerivation rec {
  pname = "network-manager-applet";
  version = "1.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/network-manager-applet/${lib.versions.majorMinor version}/network-manager-applet-${version}.tar.xz";
    sha256 = "sha256-qEcESH6jr+FIXEf7KrWYuPd59UCuDcvwocX4XmSn4lM=";
  };

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

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

  mesonFlags = [
    "-Dselinux=false"
    "-Dappindicator=yes"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/network-manager-applet/";
    description = "NetworkManager control applet for GNOME";
    license = lib.licenses.gpl2Plus;
    mainProgram = "nm-applet";
    platforms = lib.platforms.linux;
  };
}
