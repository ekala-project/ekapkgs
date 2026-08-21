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
}:

stdenv.mkDerivation rec {
  pname = "libvirt";
  version = "11.1.0";

  src = fetchurl {
    url = "https://libvirt.org/sources/libvirt-${version}.tar.xz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    meson ninja pkg-config python3 perl gettext docutils rpcsvc-proto
  ];

  buildInputs = [
    libxml2 gnutls libgcrypt dbus libnl libpciaccess yajl
    libtirpc readline numactl systemd libpcap libtasn1 curl bash
  ];

  mesonFlags = [
    "-Ddriver_qemu=enabled"
    "-Ddriver_libvirtd=enabled"
    "-Dstorage_dir=enabled"
    "-Dstorage_fs=enabled"
    "-Dstorage_disk=enabled"
    "-Dstorage_logical=enabled"
    "-Ddocs=disabled"
    "-Dtests=disabled"
    "-Dinit_script=systemd"
    "-Drunstatedir=/run"
  ];

  meta = {
    description = "Toolkit to interact with virtualization capabilities of Linux";
    homepage = "https://libvirt.org";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
