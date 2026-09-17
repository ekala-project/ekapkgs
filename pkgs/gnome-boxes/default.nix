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
  acl,
  adwaita-icon-theme,
  cdrkit,
  cyrus_sasl,
  gdbm,
  gmp,
  libapparmor,
  libcap,
  libcap_ng,
  libcdio,
  libgudev,
  libhandy,
  libosinfo,
  librsvg,
  libusb1,
  libvirt,
  # TODO: libvirt-glib - not available
  mtools,
  numactl,
  qemu-utils,
  spice-gtk,
  spice-protocol,
  systemd,
  vte,
  # TODO: webkitgtk_4_1 (webkitgtk) - not available
  yajl,
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

  propagatedUserEnvPkgs = [ spice-gtk ];

  buildInputs = [
    acl
    adwaita-icon-theme
    cyrus_sasl
    gdbm
    glib
    glib-networking
    gmp
    gtk3
    json-glib
    libapparmor
    libarchive
    libcap
    libcap_ng
    libgudev
    libhandy
    libosinfo
    libportal.gtk3
    librsvg
    libsoup_3
    libusb1
    libvirt
    # TODO: libvirt-glib - not available
    libxml2
    numactl
    spice-gtk
    spice-protocol
    systemd
    vte
    # TODO: webkitgtk_4_1 - not available
    yajl
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${
      lib.makeBinPath [
        mtools
        cdrkit
        libcdio
        qemu-utils
      ]
    }")
  '';

  meta = {
    description = "Simple GNOME application to access virtual systems";
    mainProgram = "gnome-boxes";
    homepage = "https://apps.gnome.org/Boxes/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
