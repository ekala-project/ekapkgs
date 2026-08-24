{
  lib,
  stdenv,
  fetchurl,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  glib,
  libxslt,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-dbus-proxy";
  version = "0.1.8";

  src = fetchurl {
    url = "https://github.com/flatpak/xdg-dbus-proxy/releases/download/${finalAttrs.version}/xdg-dbus-proxy-${finalAttrs.version}.tar.xz";
    hash = "sha256-tmML0k+BYbDiVG0qy7AUo7Mkn1wNdfKoY63omLkDTT0=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    docbook_xml_dtd_43
    libxslt
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  # dbus[2345]: Failed to start message bus: Failed to open "/etc/dbus-1/session.conf": No such file or directory
  doCheck = false;

  meta = {
    description = "DBus proxy for Flatpak and others";
    homepage = "https://github.com/flatpak/xdg-dbus-proxy";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "xdg-dbus-proxy";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
