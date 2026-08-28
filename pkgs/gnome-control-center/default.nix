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
  # TODO: gnome-settings-daemon - being ported
  # TODO: gnome-online-accounts - being ported
  # TODO: mutter - being ported
  # TODO: tinysparql - being ported
  # TODO: networkmanager - not available
  # TODO: libnma (libnma-gtk4) - not available
  # TODO: libwacom - not available
  # TODO: samba - not available
  # TODO: gnome-bluetooth - not available (gnome-bluetooth_1_0)
  # TODO: blueprint-compiler - not yet available in ekapkgs
  # TODO: docbook-xsl-nons - not yet available in ekapkgs
  # TODO: fontconfig - not yet available in ekapkgs
  # TODO: gdk-pixbuf - not yet available in ekapkgs
  # TODO: libxslt - not yet available in ekapkgs
  # TODO: shared-mime-info - not yet available in ekapkgs
  # TODO: wayland-scanner - not yet available in ekapkgs
  # TODO: adwaita-icon-theme - not yet available in ekapkgs
  # TODO: colord-gtk4 - not yet available in ekapkgs
  # TODO: gmobile - not yet available in ekapkgs
  # TODO: gnome-color-manager - not yet available in ekapkgs
  # TODO: gnome-remote-desktop - not yet available in ekapkgs
  # TODO: gnome-tecla - not yet available in ekapkgs
  # TODO: gnome-user-share - not yet available in ekapkgs
  # TODO: gsound - not yet available in ekapkgs
  # TODO: gstreamer - not yet available in ekapkgs
  # TODO: libepoxy - not yet available in ekapkgs
  # TODO: libgtop - not yet available in ekapkgs
  # TODO: libgudev - not yet available in ekapkgs
  # TODO: libkrb5 - not yet available in ekapkgs
  # TODO: libpulseaudio - not yet available in ekapkgs
  # TODO: libpwquality - not yet available in ekapkgs
  # TODO: librsvg - not yet available in ekapkgs
  # TODO: libsoup_3 - not yet available in ekapkgs
  # TODO: localsearch - not yet available in ekapkgs
  # TODO: modemmanager - not yet available in ekapkgs
  # TODO: networkmanagerapplet - not yet available in ekapkgs
  # TODO: sound-theme-freedesktop - not yet available in ekapkgs
  # TODO: udisks - not yet available in ekapkgs
  # TODO: libjxl - not yet available in ekapkgs
  # TODO: webp-pixbuf-loader - not yet available in ekapkgs
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
  # patches = [
  #   (replaceVars ./paths.patch {
  #     gcm = gnome-color-manager;
  #     inherit glibc tzdata shadow;
  #     inherit cups networkmanagerapplet;
  #   })
  # ];

  nativeBuildInputs = [
    # TODO: blueprint-compiler
    # TODO: docbook-xsl-nons
    gettext
    # TODO: libxslt
    meson
    ninja
    pkg-config
    python3
    # TODO: shared-mime-info
    # TODO: wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    # TODO: adwaita-icon-theme
    colord
    # TODO: colord-gtk4
    cups
    # TODO: fontconfig
    # TODO: gdk-pixbuf
    glib
    glib-networking
    gcr_4
    # TODO: gmobile
    # TODO: gnome-bluetooth - not available
    gnome-desktop
    # TODO: gnome-online-accounts - being ported
    # TODO: gnome-remote-desktop
    # TODO: gnome-settings-daemon - being ported
    # TODO: gnome-tecla
    # TODO: gnome-user-share
    gsettings-desktop-schemas
    # TODO: gsound
    gtk3 # org.gtk.Settings.FileChooser schema (datetime panel sets clock-format)
    gtk4
    ibus
    json-glib
    # TODO: libepoxy
    # TODO: libgtop
    # TODO: libgudev
    libadwaita
    # TODO: libkrb5
    # TODO: libnma-gtk4 - not available
    # TODO: libpulseaudio
    # TODO: libpwquality
    # TODO: librsvg
    libsecret
    # TODO: libsoup_3
    # TODO: libwacom - not available
    libxml2
    # TODO: modemmanager
    # TODO: mutter - being ported (schemas for keybindings)
    # TODO: networkmanager - not available
    polkit
    # TODO: samba - not available
    # TODO: tinysparql - being ported
    # TODO: localsearch (for search locations dialog)
    # TODO: udisks
    upower
    # TODO: gst_all_1.gst-plugins-base
    # TODO: gst_all_1.gst-plugins-good
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

  # TODO: uncomment once pixbuf loader deps are available
  # postInstall = ''
  #   export GDK_PIXBUF_MODULE_FILE="..."
  # '';

  # TODO: uncomment once sound-theme-freedesktop, gdk-pixbuf, librsvg, mutter are available
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
