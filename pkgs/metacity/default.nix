{
  lib,
  stdenv,
  fetchurl,
  gettext,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  libxres,
  libxpresent,
  libxdamage,
  libx11,
  libcanberra-gtk3 ? null,
  libgtop,
  libstartup_notification,
  libxml2,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "metacity";
  version = "3.58.1";

  src = fetchurl {
    url = "mirror://gnome/sources/metacity/${lib.versions.majorMinor finalAttrs.version}/metacity-${finalAttrs.version}.tar.xz";
    hash = "sha256-5DDIqSQJ7y+RpNq9UKcePTu8xHSj3sHK7DgTs4HX0bA=";
  };

  nativeBuildInputs = [
    gettext
    libxml2
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libxres
    libxpresent
    libxdamage
    libx11
    glib
    gsettings-desktop-schemas
    gtk3
    libgtop
    libstartup_notification
  ]
  ++ lib.optional (libcanberra-gtk3 != null) libcanberra-gtk3;

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Window manager used in Gnome Flashback";
    homepage = "https://gitlab.gnome.org/GNOME/metacity";
    changelog = "https://gitlab.gnome.org/GNOME/metacity/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
