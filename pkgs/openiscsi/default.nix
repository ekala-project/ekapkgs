{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  perl,
  util-linux,
  open-isns,
  openssl,
  kmod,
  systemd,
  runtimeShell,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open-iscsi";
  version = "2.1.13";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = finalAttrs.version;
    hash = "sha256-omQ1cWVqAoIwKJRUUmGBLDyJy80Pwk3OnHWOrfzdvj8=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
    perl
    udevCheckHook
  ];
  buildInputs = [
    kmod
    open-isns
    openssl
    systemd
    util-linux
  ];

  preConfigure = ''
    patchShebangs .
  '';

  prePatch = ''
    substituteInPlace etc/systemd/iscsi-init.service.template \
      --replace /usr/bin/sh ${runtimeShell}
    sed -i '/install_dir: db_root/d' meson.build
  '';

  mesonEntries = {
    iscsi_sbindir = "${placeholder ";
    rulesdir = "${placeholder ";
    systemddir = "${placeholder ";
    dbroot = "/etc/iscsi";
  };

  mesonFlags = [
    out"}/sbin"
    out"}/etc/udev/rules.d"
    out"}/lib/systemd"
  ];
  meta = {
    description = "High performance, transport independent, multi-platform implementation of RFC3720";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.open-iscsi.com";
    platforms = lib.platforms.linux;
  };
})
