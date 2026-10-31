{
  stdenv,
  lib,
  fetchurl,
  openvpn,
  gettext,
  libxml2,
  pkg-config,
  file,
  networkmanager,
  libsecret,
  glib,
  gtk3,
  gtk4,
  withGnome ? true,
  kmod,
  libnma,
  libnma-gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "NetworkManager-openvpn";
  version = "1.12.5";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager-openvpn/${lib.versions.majorMinor finalAttrs.version}/NetworkManager-openvpn-${finalAttrs.version}.tar.xz";
    sha256 = "zjLjiwUA7d8vyAcsoXZ5gX/C0165H2/3uZBCCcFLWv0=";
  };

  nativeBuildInputs = [
    gettext
    glib
    pkg-config
    file
    libxml2
  ];

  buildInputs = [
    openvpn
    networkmanager
  ]
  ++ lib.optionals withGnome [
    gtk3
    gtk4
    libsecret
    libnma
    libnma-gtk4
  ];

  configureFlags = [
    "--with-gnome=${lib.boolToYesNo withGnome}"
    "--with-gtk4=${lib.boolToYesNo withGnome}"
    "--localstatedir=/"
    "--enable-absolute-paths"
  ];

  strictDeps = true;

  passthru = {
    networkManagerPlugin = "VPN/nm-openvpn-service.name";
  };

  meta = {
    description = "NetworkManager's OpenVPN plugin";
    homepage = "https://gitlab.gnome.org/GNOME/NetworkManager-openvpn";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
