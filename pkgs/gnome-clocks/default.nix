{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  gettext,
  pkg-config,
  itstool,
  desktop-file-utils,
  vala,
  libxml2,
  gtk4,
  glib,
  gsettings-desktop-schemas,
  gnome-desktop,
  geocode-glib_2,
  gdk-pixbuf,
  geoclue2,
  gstreamer,
  icu,
  libgweather,
  libadwaita,
  vorbis-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-clocks";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${lib.versions.major finalAttrs.version}/gnome-clocks-${finalAttrs.version}.tar.xz";
    hash = "sha256-vxZ/f0T08vtCTUcWZSybofKeFuSQceJqG7gz+NznlMY=";
  };

  nativeBuildInputs = [
    vala
    vorbis-tools
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    itstool
    gtk4.wrapGAppsHook
    desktop-file-utils
    libxml2
  ];

  buildInputs = [
    gtk4
    glib
    gsettings-desktop-schemas
    gdk-pixbuf
    gnome-desktop
    geocode-glib_2
    geoclue2
    icu
    libgweather
    libadwaita
  ]
  ++ (with gstreamer; [
    # GStreamer plugins needed for Alarms
    gstreamer
    plugins-base
    plugins-good
  ]);

  doCheck = true;

  meta = {
    homepage = "https://apps.gnome.org/Clocks/";
    description = "Simple and elegant clock application for GNOME";
    mainProgram = "gnome-clocks";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
