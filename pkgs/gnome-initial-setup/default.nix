{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  # TODO: dconf (not yet ported)
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  accountsservice,
  fontconfig,
  # TODO: gdm (not yet ported)
  # TODO: geoclue2 (not yet ported)
  # TODO: geocode-glib_2 (not yet ported)
  glib,
  gnome-desktop,
  gtk4,
  # TODO: libgweather (being ported)
  json-glib,
  # TODO: krb5 (not yet ported)
  # TODO: libpwquality (not yet ported)
  libsecret,
  # TODO: networkmanager (not yet ported)
  pango,
  polkit,
  # TODO: webkitgtk_6_0 (not available)
  # TODO: systemd - needed as nativeBuildInput
  libadwaita,
  # TODO: libnma-gtk4 (not yet ported)
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
    # TODO: dconf
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    # TODO: systemd (needed as native build input for unit dir detection)
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    fontconfig
    # TODO: gdm
    # TODO: geoclue2
    # TODO: geocode-glib_2
    glib
    gnome-desktop
    gsettings-desktop-schemas
    gtk4
    json-glib
    # TODO: krb5
    # TODO: libgweather (being ported)
    libadwaita
    # TODO: libnma-gtk4
    # TODO: libpwquality
    libsecret
    # TODO: networkmanager
    pango
    polkit
    # TODO: webkitgtk_6_0 (not available)
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
