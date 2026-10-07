{
  stdenv,
  lib,
  fetchurl,
  appstream,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk4,
  desktop-file-utils,
  gettext,
  itstool,
  libadwaita,
  libxml2,
  libxslt,
  docbook-xsl-nons,
  docbook-xml-dtd,
  systemd,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-logs";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major finalAttrs.version}/gnome-logs-${finalAttrs.version}.tar.xz";
    hash = "sha256-tGbGZgFVUhuoE1M5xt8ICg4HGkb5kRuZFysh+eLf2Ag=";
  };

  nativeBuildInputs = [
    appstream
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk4.wrapGAppsHook
    gettext
    itstool
    libxml2
    libxslt
    docbook-xsl-nons
    docbook-xml-dtd.v4_3
    glib
    gtk4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    systemd
    gsettings-desktop-schemas
  ];

  mesonEntries = {
    man = true;
  };

  doCheck = true;

  meta = {
    homepage = "https://apps.gnome.org/Logs/";
    description = "Log viewer for the systemd journal";
    mainProgram = "gnome-logs";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
