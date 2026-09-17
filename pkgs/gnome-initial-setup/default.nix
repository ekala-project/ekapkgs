{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  dconf,
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  accountsservice,
  fontconfig,
  gdm,
  geoclue2,
  geocode-glib_2,
  glib,
  gnome-desktop,
  gnome-bluetooth,
  gtk4,
  libgweather,
  json-glib,
  krb5,
  libpwquality,
  libsecret,
  networkmanager,
  pango,
  polkit,
  # TODO: webkitgtk_6_0 (not available in ekapkgs)
  systemd,
  libadwaita,
  # TODO: libnma-gtk4 (not available in ekapkgs)
  tzdata,
  gnome-tecla,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-initial-setup";
  version = "50.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-initial-setup/${lib.versions.major finalAttrs.version}/gnome-initial-setup-${finalAttrs.version}.tar.xz";
    hash = "sha256-su0FI1iW9H9VJJirWrKfVQHmqMQe5kXyqRhiCx3pHmA=";
  };

  patches = [
    (replaceVars ./0001-fix-paths.patch {
      inherit tzdata;
      tecla = gnome-tecla;
    })
  ];

  nativeBuildInputs = [
    dconf
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    systemd
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    fontconfig
    gdm
    geoclue2
    geocode-glib_2
    glib
    gnome-bluetooth
    gnome-desktop
    gsettings-desktop-schemas
    gtk4
    json-glib
    krb5
    libgweather
    libadwaita
    # TODO: libnma-gtk4 (not available in ekapkgs)
    libpwquality
    libsecret
    networkmanager
    pango
    polkit
    # TODO: webkitgtk_6_0 (not available in ekapkgs)
  ];

  mesonFlags = [
    "-Dibus=disabled"
    "-Dparental_controls=disabled"
    "-Dvendor-conf-file=${./vendor.conf}"
  ];

  meta = {
    description = "Simple, easy, and safe way to prepare a new system";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-initial-setup";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-initial-setup/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
