{
  stdenv,
  lib,
  desktop-file-utils,
  fetchurl,
  elfutils,
  gettext,
  glib,
  gtk4,
  json-glib,
  itstool,
  libadwaita,
  libdex,
  libpanel,
  libunwind,
  libxml2,
  meson,
  ninja,
  pkg-config,
  polkit,
  shared-mime-info,
  systemd,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysprof";
  version = "50.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/sysprof/${lib.versions.major finalAttrs.version}/sysprof-${finalAttrs.version}.tar.xz";
    hash = "sha256-qs5E6Q6Q9sNLsvvsjMtHuPgRAwgJeNZXWSh4Q8Mp1To=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    libxml2
    meson
    ninja
    pkg-config
    shared-mime-info
    wrapGAppsHook4
  ];

  buildInputs = [
    elfutils
    glib
    gtk4
    json-glib
    polkit
    systemd
    libadwaita
    libdex
    libpanel
    libunwind
  ];

  mesonFlags = [
    "-Dsystemdunitdir=lib/systemd/system"
    "-Dinstall-static=false"
  ];

  meta = {
    description = "System-wide profiler for Linux";
    homepage = "https://gitlab.gnome.org/GNOME/sysprof";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
