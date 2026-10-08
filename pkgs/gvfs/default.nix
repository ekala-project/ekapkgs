{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  replaceVars,
  gettext,
  dbus,
  glib,
  udevSupport ? stdenv.hostPlatform.isLinux,
  libgudev,
  # udisks excluded - fails to build due to Haskell dep chain
  libgcrypt,
  libcap,
  polkit,
  libgphoto2,
  avahi,
  libarchive,
  fuse,
  libcdio,
  libxml2,
  libsoup_3,
  libxslt,
  docbook_xsl,
  docbook-xml-dtd,
  samba,
  libmtp,
  gnomeSupport ? false,
  gtk3,
  libimobiledevice,
  libbluray,
  libcdio-paranoia,
  libnfs,
  openssh,
  libsecret ? null,
  python3,
  gsettings-desktop-schemas,
  # tinysparql is null - disable tracker support
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gvfs";
  version = "1.60.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/${lib.versions.majorMinor finalAttrs.version}/gvfs-${finalAttrs.version}.tar.xz";
    hash = "sha256-kOq6Mzq30xp/3q3kWVSlE8NmHM672aE4qrP7SB37nkA=";
  };

  patches = [
    (replaceVars ./hardcode-ssh-path.patch {
      ssh_program = "${lib.getBin openssh}/bin/ssh";
    })
  ];

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    python3
    pkg-config
    gettext
    gtk3.wrapGAppsHook
    libxslt
    docbook_xsl
    docbook-xml-dtd.v4_2
  ];

  buildInputs = [
    glib
    libgcrypt
    dbus
    libgphoto2
    avahi
    libarchive
    libimobiledevice
    libbluray
    libnfs
    libxml2
    gsettings-desktop-schemas
    libsoup_3
  ]
  ++ lib.optionals udevSupport ([
    libgudev
    fuse
    libcdio
    samba
    libmtp
    libcap
    polkit
    libcdio-paranoia
  ]);

  mesonEntries = {
    systemduserunitdir = "${placeholder "out"}/lib/systemd/user";
    tmpfilesdir = "no";
    udisks2 = false;
    gcr = false;
    goa = false;
    keyring = false;
    onedrive = false;
  };

  mesonFlags = [
  ]
  ++ lib.optionals (!udevSupport) [
    "-Dgudev=false"
    "-Dfuse=false"
    "-Dcdda=false"
    "-Dsmb=false"
    "-Dmtp=false"
    "-Dadmin=false"
    "-Dgphoto2=false"
    "-Dlibusb=false"
    "-Dlogind=false"
  ]
  ++ lib.optionals (avahi == null) [
    "-Ddnssd=false"
  ]
  ++ lib.optionals (samba == null) [
    "-Dsmb=false"
  ];

  doCheck = false;
  doInstallCheck = finalAttrs.finalPackage.doCheck;

  separateDebugInfo = true;

  meta = {
    description = "Virtual Filesystem support library";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
