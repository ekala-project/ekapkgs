{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  kmod,
  open-isns,
  systemd,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open-iscsi";
  version = "2.1.11";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    tag = "${finalAttrs.version}";
    hash = "sha256-Xs2EiNSkRtAQPoagCAKl07VndYKDspGLchxMvsfvTi0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    kmod
    open-isns
    openssl
    systemd
    util-linux
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "DESTDIR="
    "sbindir=$(out)/bin"
    "etcdir=$(out)/etc/iscsi"
    "dbroot=$(out)/var/lib/iscsi"
  ];

  installFlags = [
    "install"
    "install_systemd"
  ];

  meta = {
    description = "iSCSI initiator utilities for Linux";
    homepage = "https://github.com/open-iscsi/open-iscsi";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
