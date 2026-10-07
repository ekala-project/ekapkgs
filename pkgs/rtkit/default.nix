{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  unixtools,
  dbus,
  libcap,
  polkit,
  systemd,
}:

stdenv.mkDerivation {
  pname = "rtkit";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "heftig";
    repo = "rtkit";
    rev = "c295fa849f52b487be6433e69e08b46251950399";
    sha256 = "0yfsgi3pvg6dkizrww1jxpkvcbhzyw9110n1dypmzq0c5hlzjxcd";
  };

  patches = [
    ./meson-actual-use-systemd_systemunitdir.patch
    ./meson-fix-librt-find_library-check.patch
    ./rtkit-daemon-dont-log-debug-messages-by-default.patch
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    unixtools.xxd
  ];

  buildInputs = [
    dbus
    libcap
    polkit
    systemd
  ];

  mesonEntries = {
    installed_tests = false;
    dbus_systemservicedir = "${placeholder ";
    dbus_interfacedir = "${placeholder ";
    dbus_rulesdir = "${placeholder ";
    polkit_actiondir = "${placeholder ";
    systemd_systemunitdir = "${placeholder ";
  };

  mesonFlags = [
    out"}/share/dbus-1/system-services"
    out"}/share/dbus-1/interfaces"
    out"}/etc/dbus-1/system.d"
    out"}/share/polkit-1/actions"
    out"}/etc/systemd/system"
  ];

  meta = {
    homepage = "https://github.com/heftig/rtkit";
    description = "Daemon that hands out real-time priority to processes";
    mainProgram = "rtkitctl";
    license = with lib.licenses; [
      gpl3
      bsd0
    ];
    platforms = lib.platforms.linux;
  };
}
