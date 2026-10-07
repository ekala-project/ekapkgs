{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  bashInteractive,
  dbus,
  docbook2x,
  libapparmor,
  libcap,
  libseccomp,
  libselinux,
  meson,
  ninja,
  openssl,
  pkg-config,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxc";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eB68l7SmVxJViGmVlVtEXVD+cRtr4WqOrA8b9ImQ89g=";
  };

  nativeBuildInputs = [
    docbook2x
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    bashInteractive
    dbus
    libapparmor
    libcap
    libseccomp
    libselinux
    openssl
    systemd
  ];

  mesonEntries = {
    install-init-files = true;
    install-state-dirs = false;
    specfile = false;
    tools-multicall = true;
    tools = false;
    usernet-config-path = "/etc/lxc/lxc-usernet";
    distrosysconfdir = "${placeholder ";
    systemd-unitdir = "${placeholder ";
    man = false;
  };

  mesonFlags = [
    out"}/etc/lxc"
    out"}/lib/systemd/system"
  ];

  postInstall = ''
    substituteInPlace $out/etc/lxc/lxc --replace-fail "$out/etc/lxc" "/etc/lxc"
    substituteInPlace $out/libexec/lxc/lxc-net --replace-fail "$out/etc/lxc" "/etc/lxc"

    substituteInPlace $out/share/lxc/templates/lxc-download --replace-fail "$out/share" "/run/current-system/sw/share"
    substituteInPlace $out/share/lxc/templates/lxc-local --replace-fail "$out/share" "/run/current-system/sw/share"
    substituteInPlace $out/share/lxc/templates/lxc-oci --replace-fail "$out/share" "/run/current-system/sw/share"

    substituteInPlace $out/share/lxc/config/common.conf --replace-fail "$out/share" "/run/current-system/sw/share"
    substituteInPlace $out/share/lxc/config/userns.conf --replace-fail "$out/share" "/run/current-system/sw/share"
    substituteInPlace $out/share/lxc/config/oci.common.conf --replace-fail "$out/share" "/run/current-system/sw/share"
  '';


  doCheck = true;

  meta = {
    homepage = "https://linuxcontainers.org/";
    description = "Userspace tools for Linux Containers, a lightweight virtualization system";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
