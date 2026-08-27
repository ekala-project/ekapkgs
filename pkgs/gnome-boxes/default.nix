{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  wrapGAppsHook3,
  pkg-config,
  gettext,
  itstool,
  glib,
  gobject-introspection,
  libxml2,
  gtk3,
  libsoup_3,
  libarchive,
  json-glib,
  glib-networking,
  vala,
  desktop-file-utils,
  libportal,
  libsecret,
  # TODO: libvirt-glib - not available
  # TODO: libvirt - not available
  # TODO: spice-gtk - not available
  # TODO: spice-protocol - not available
  # TODO: libhandy - not available
  # TODO: libosinfo - not available
  # TODO: systemd - not available
  # TODO: libcap - not available
  # TODO: yajl - not available
  # TODO: gmp - not available
  # TODO: gdbm - not available
  # TODO: cyrus_sasl - not available
  # TODO: adwaita-icon-theme - not available
  # TODO: librsvg - not available
  # TODO: mtools - not available
  # TODO: cdrkit - not available
  # TODO: libcdio - not available
  # TODO: libusb1 - not available
  # TODO: acl - not available
  # TODO: libgudev - not available
  # TODO: libcap_ng - not available
  # TODO: numactl - not available
  # TODO: libapparmor - not available
  # TODO: webkitgtk_4_1 (webkitgtk) - not available
  # TODO: vte - not available
  # TODO: qemu-utils - not available
  # TODO: libportal-gtk3 - not available (need gtk3 variant of libportal)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-boxes";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-boxes/${lib.versions.major finalAttrs.version}/gnome-boxes-${finalAttrs.version}.tar.xz";
    hash = "sha256-/Wpd4Y0QkJRsqZ8fWjSqPhXcgYP2pyIm6NFQShNnLWc=";
  };

  patches = [
    # Fix path to libgovf-0.1.so in the gir file.
    ./fix-gir-lib-path.patch
  ];

  doCheck = true;

  nativeBuildInputs = [
    gettext
    gobject-introspection
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    # For post install script
    glib
    gtk3
    desktop-file-utils
  ];

  # TODO: propagatedUserEnvPkgs = [ spice-gtk ];

  buildInputs = [
    # TODO: acl
    # TODO: cyrus_sasl
    # TODO: gdbm
    glib
    glib-networking
    # TODO: gmp
    # TODO: adwaita-icon-theme
    gtk3
    json-glib
    # TODO: libapparmor
    libarchive
    # TODO: libcap
    # TODO: libcap_ng
    # TODO: libgudev
    # TODO: libhandy
    # TODO: libosinfo
    # TODO: librsvg
    libsoup_3
    # TODO: libusb1
    # TODO: libvirt
    # TODO: libvirt-glib
    libxml2
    # TODO: numactl
    # TODO: spice-gtk
    # TODO: spice-protocol
    # TODO: systemd
    # TODO: vte
    # TODO: webkitgtk_4_1
    # TODO: yajl
    # TODO: libportal-gtk3
  ];

  # TODO: preFixup with mtools, cdrkit, libcdio, qemu-utils PATH
  # preFixup = ''
  #   gappsWrapperArgs+=(--prefix PATH : "${
  #     lib.makeBinPath [
  #       mtools
  #       cdrkit
  #       libcdio
  #       qemu-utils
  #     ]
  #   }")
  # '';

  meta = {
    description = "Simple GNOME application to access virtual systems";
    mainProgram = "gnome-boxes";
    homepage = "https://apps.gnome.org/Boxes/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
