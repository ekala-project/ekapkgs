{
  lib,
  stdenv,
  fetchFromGitLab,
  glib,
  libgudev,
  ppp,
  gettext,
  pkg-config,
  libxslt,
  python3,
  libmbim,
  libqmi,
  bash-completion,
  meson,
  ninja,
  vala,
  dbus,
  bash,
  gobject-introspection,
  polkit,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "modemmanager";
  version = "1.24.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "ModemManager";
    rev = version;
    hash = "sha256-rBLOqpx7Y2BB6/xvhIw+rDEXsLtePhHLBvfpSuJzQik=";
  };

  patches = [
    # Since /etc is the domain of NixOS, not Nix, we cannot install files there.
    # But these are just placeholders so we do not need to install them at all.
    ./no-dummy-dirs-in-sysconfdir.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    gettext
    glib
    pkg-config
    libxslt
    python3
    gobject-introspection
    vala
  ];

  buildInputs = [
    glib
    libgudev
    ppp
    libmbim
    libqmi
    bash-completion
    dbus
    bash # shebangs in share/ModemManager/fcc-unlock.available.d/
    polkit
    systemd
  ];

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    "-Ddbus_policy_dir=${placeholder "out"}/share/dbus-1/system.d"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (lib.mesonBool "introspection" true)
    (lib.mesonBool "qrtr" true)
    (lib.mesonBool "vapi" true)
    (lib.mesonBool "systemd_suspend_resume" true)
    (lib.mesonBool "systemd_journal" true)
    (lib.mesonOption "polkit" "strict")
  ];

  postPatch = ''
    patchShebangs \
      tools/test-modemmanager-service.py
  '';

  meta = {
    description = "WWAN modem manager, part of NetworkManager";
    homepage = "https://www.freedesktop.org/wiki/Software/ModemManager/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
