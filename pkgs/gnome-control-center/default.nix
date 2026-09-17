{
  fetchurl,
  lib,
  stdenv,
  replaceVars,
  accountsservice,
  colord,
  cups,
  dbus,
  gettext,
  glib,
  glib-networking,
  gcr_4,
  gnome-desktop,
  gsettings-desktop-schemas,
  gtk3,
  gtk4,
  ibus,
  json-glib,
  libadwaita,
  libsecret,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  polkit,
  upower,
  wrapGAppsHook4,
  gnome-settings-daemon,
  gnome-online-accounts,
  mutter,
  tinysparql,
  networkmanager,
  gnome-bluetooth,
  blueprint-compiler,
  docbook-xsl-nons,
  fontconfig,
  gdk-pixbuf,
  libxslt,
  shared-mime-info,
  wayland-scanner,
  adwaita-icon-theme,
  gnome-user-share,
  gst_all_1,
  libepoxy,
  libgtop,
  libgudev,
  libkrb5,
  libpulseaudio,
  librsvg,
  libsoup_3,
  localsearch,
  libjxl,
  webp-pixbuf-loader,
  # TODO: libnma (libnma-gtk4) - not available
  # TODO: libwacom - not available
  # TODO: samba - not available
  # TODO: colord-gtk4 - not yet available in ekapkgs
  # TODO: gmobile - not yet available in ekapkgs
  # TODO: gnome-color-manager - not yet available in ekapkgs
  # TODO: gnome-remote-desktop - not yet available in ekapkgs
  # TODO: gnome-tecla - not yet available in ekapkgs
  # TODO: gsound - not yet available in ekapkgs
  # TODO: libpwquality - not yet available in ekapkgs
  # TODO: modemmanager - not yet available in ekapkgs
  # TODO: networkmanagerapplet - not yet available in ekapkgs
  # TODO: sound-theme-freedesktop - not yet available in ekapkgs
  # TODO: udisks - not yet available in ekapkgs
  # TODO: shadow - not yet available in ekapkgs
  # TODO: glibc (for i18n locales path) - not yet available in ekapkgs
  # TODO: tzdata - not yet available in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-control-center";
  version = "50.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/${lib.versions.major finalAttrs.version}/gnome-control-center-${finalAttrs.version}.tar.xz";
    hash = "sha256-WFbHOZm+30XnT3O6w9YeK17BaJ+LzxlDc3uu7oIE+xE=";
  };

  # TODO: uncomment once all replaceVars deps are available
  # Still missing: gnome-color-manager, glibc, tzdata, shadow, networkmanagerapplet
  # patches = [
  #   (replaceVars ./paths.patch {
  #     gcm = gnome-color-manager;
  #     inherit glibc tzdata shadow;
  #     inherit cups networkmanagerapplet;
  #   })
  # ];

  nativeBuildInputs = [
    blueprint-compiler
    docbook-xsl-nons
    gettext
    libxslt
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    adwaita-icon-theme
    colord
    # TODO: colord-gtk4 - not yet available in ekapkgs
    cups
    fontconfig
    gdk-pixbuf
    glib
    glib-networking
    gcr_4
    # TODO: gmobile - not yet available in ekapkgs
    gnome-bluetooth
    gnome-desktop
    gnome-online-accounts
    # TODO: gnome-remote-desktop - not yet available in ekapkgs
    gnome-settings-daemon
    # TODO: gnome-tecla - not yet available in ekapkgs
    gnome-user-share
    gsettings-desktop-schemas
    # TODO: gsound - not yet available in ekapkgs
    gtk3 # org.gtk.Settings.FileChooser schema (datetime panel sets clock-format)
    gtk4
    ibus
    json-glib
    libepoxy
    libgtop
    libgudev
    libadwaita
    libkrb5
    # TODO: libnma-gtk4 - not available
    libpulseaudio
    # TODO: libpwquality - not yet available in ekapkgs
    librsvg
    libsecret
    libsoup_3
    # TODO: libwacom - not available
    libxml2
    # TODO: modemmanager - not yet available in ekapkgs
    mutter # schemas for keybindings
    networkmanager
    polkit
    # TODO: samba - not available
    tinysparql
    localsearch # for search locations dialog
    # TODO: udisks - not yet available in ekapkgs
    upower
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  preCheck = ''
    # Basically same as https://github.com/NixOS/nixpkgs/pull/141299
    export ADW_DISABLE_PORTAL=1
    export XDG_DATA_DIRS=${glib.getSchemaDataDirPath gsettings-desktop-schemas}
  '';

  # TODO: uncomment and fill in GDK_PIXBUF_MODULE_FILE path once pixbuf loader integration is finalized
  # gdk-pixbuf, libjxl, and webp-pixbuf-loader are now available
  # postInstall = ''
  #   export GDK_PIXBUF_MODULE_FILE="..."
  # '';

  # TODO: uncomment once sound-theme-freedesktop is available
  # (gdk-pixbuf, librsvg, mutter are now available)
  # preFixup = ''
  #   gappsWrapperArgs+=(
  #     --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share"
  #     --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
  #     --prefix XDG_DATA_DIRS : "${librsvg}/share"
  #     --prefix XDG_DATA_DIRS : "${mutter}/share"
  #   )
  # '';

  separateDebugInfo = true;

  meta = {
    description = "Utilities to configure the GNOME desktop";
    mainProgram = "gnome-control-center";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
