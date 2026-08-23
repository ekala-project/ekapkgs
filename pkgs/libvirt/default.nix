{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  perl,
  libxml2,
  gnutls,
  libgcrypt,
  dbus,
  libnl,
  libpciaccess,
  yajl,
  libtirpc,
  rpcsvc-proto,
  readline,
  numactl,
  systemd,
  libpcap,
  libtasn1,
  iptables,
  ebtables,
  iproute2,
  coreutils,
  util-linux,
  curl,
  bash,
  gettext,
  docutils,
  libxslt,
  attr,
  acl,
}:

stdenv.mkDerivation rec {
  pname = "libvirt";
  version = "11.1.0";

  src = fetchurl {
    url = "https://libvirt.org/sources/libvirt-${version}.tar.xz";
    hash = "sha256-Ga6/2Y0gl5LVac3PlE2vuFwA0mTztV+hIWsY+bycsiY=";
  };

  nativeBuildInputs = [
    meson meson.configurePhaseHook ninja pkg-config python3 perl gettext docutils rpcsvc-proto libxslt
  ];

  buildInputs = [
    libxml2 gnutls libgcrypt dbus libnl libpciaccess yajl
    libtirpc readline numactl systemd libpcap libtasn1 curl bash
    attr acl
  ];

  mesonFlags = [
    "-Ddriver_qemu=enabled"
    "-Ddriver_libvirtd=enabled"
    "-Dstorage_dir=enabled"
    "-Dstorage_fs=enabled"
    "-Ddocs=disabled"
    "-Dtests=disabled"
    "-Dinit_script=systemd"
    "-Drunstatedir=/run"
    "-Dapparmor=disabled"
    "-Dapparmor_profiles=disabled"
    "-Dselinux=disabled"
    "-Daudit=disabled"
    "-Dwireshark_dissector=disabled"
    "-Dlibssh=disabled"
    "-Dlibssh2=disabled"
    "-Dsasl=disabled"
    "-Dpolkit=disabled"
    "-Dsanlock=disabled"
    "-Dlibiscsi=disabled"
    "-Dglusterfs=disabled"
    "-Dopenwsman=disabled"
    "-Dnbdkit=disabled"
    # "-Dnbd=disabled"
    "-Dfuse=disabled"
    "-Dblkid=disabled"
    "-Dbash_completion=disabled"
  ];

  meta = {
    description = "Toolkit to interact with virtualization capabilities of Linux";
    homepage = "https://libvirt.org";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
