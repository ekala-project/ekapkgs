{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  pkg-config,
  gnused,
  autoreconfHook,
  gtk-doc,
  acl,
  systemd,
  glib,
  libatasmart,
  polkit,
  coreutils,
  bash,
  which,
  expat,
  libxslt,
  docbook_xsl,
  util-linux,
  mdadm,
  libgudev,
  libblockdev,
  parted,
  gobject-introspection,
  docbook_xml_dtd_412,
  docbook_xml_dtd_43,
  xfsprogs,
  f2fs-tools,
  dosfstools,
  e2fsprogs,
  btrfs-progs,
  exfat,
  nilfs-utils,
  ntfs3g,
  libiscsi,
  libconfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udisks";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "udisks";
    tag = "udisks-${finalAttrs.version}";
    hash = "sha256-bzTposLFl8jrRr+MphV8uM60TBFPuvwEKBUgVlq1YNo=";
  };

  outputs = [
    "out"
    "man"
    "dev"
  ];

  patches = [
    (replaceVars ./fix-paths.patch {
      false = "${coreutils}/bin/false";
      mdadm = "${mdadm}/bin/mdadm";
      sed = "${gnused}/bin/sed";
      sh = "${bash}/bin/sh";
      sleep = "${coreutils}/bin/sleep";
      true = "${coreutils}/bin/true";
    })
    (replaceVars ./force-path.patch {
      path = lib.makeBinPath [
        btrfs-progs
        coreutils
        dosfstools
        e2fsprogs
        exfat
        f2fs-tools
        nilfs-utils
        xfsprogs
        ntfs3g
        parted
        util-linux
      ];
    })
  ];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    autoreconfHook
    which
    gobject-introspection
    pkg-config
    gtk-doc
    libxslt
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook_xsl
  ];

  buildInputs = [
    expat
    libgudev
    libblockdev
    acl
    systemd
    glib
    libatasmart
    polkit
    util-linux
    libiscsi
    libconfig
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--disable-gtk-doc"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-udevdir=$(out)/lib/udev"
    "--with-tmpfilesdir=no"
    "--enable-all-modules"
    "--enable-btrfs"
    "--enable-lvm2"
    "--enable-smart"
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(dev)/share/gir-1.0"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Daemon, tools and libraries to access and manipulate disks and storage devices";
    homepage = "https://www.freedesktop.org/wiki/Software/udisks/";
    license = with lib.licenses; [
      lgpl2Plus
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
