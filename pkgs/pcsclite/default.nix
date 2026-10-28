{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  flex,
  pkg-config,
  perl,
  python3,
  dbus,
  systemdLibs,
  udev,
  libusb1,
  dbusSupport ? stdenv.hostPlatform.isLinux,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  udevSupport ? dbusSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcsclite";
  version = "2.4.1";

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
    "man"
  ];

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "rousseau";
    repo = "PCSC";
    tag = finalAttrs.version;
    hash = "sha256-I4kWToLixfkP0XaONiWqNLXXmz+3n+LafbITfZOxLZw=";
  };

  mesonEntries = {
    sysconfdir = "/etc";
    usbdropdir = "/var/lib/pcsc/drivers";
    ipcdir = "/run/pcscd";
    libsystemd = systemdSupport;
    polkit = false;
    libudev = udevSupport;
  }
  // lib.optionalAttrs systemdSupport {
    systemdunit = "system";
  };

  postPatch = ''
    substituteInPlace src/libredirect.c src/spy/libpcscspy.c \
      --replace-fail "libpcsclite_real.so.1" "$lib/lib/libpcsclite_real.so.1"
    substituteInPlace meson.build \
      --replace-fail \
        "install_dir : get_option('sysconfdir') / 'default'" \
        "install_dir : '${placeholder "out"}/etc/default'"
  ''
  + lib.optionalString systemdSupport ''
    substituteInPlace meson.build \
      --replace-fail \
        "systemdsystemunitdir = systemd.get_variable(pkgconfig : 'systemd' + systemdunit + 'unitdir')" \
        "systemdsystemunitdir = '${placeholder "out"}/lib/systemd/system'"
    substituteInPlace meson.build \
      --replace-fail \
        "sysusersdir = systemd.get_variable(pkgconfig : 'sysusersdir')" \
        "sysusersdir = '${placeholder "out"}/lib/sysusers.d'"
  '';

  postInstall = ''
    # pcsc-spy is a debugging utility and it drags python into the closure
    moveToOutput bin/pcsc-spy "$dev"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    flex
    pkg-config
    perl
  ];

  buildInputs = [
    python3
  ]
  ++ lib.optionals systemdSupport [ systemdLibs ]
  ++ lib.optionals (!systemdSupport && udevSupport) [ udev ]
  ++ lib.optionals dbusSupport [ dbus ]
  ++ lib.optionals (!udevSupport) [ libusb1 ];

  meta = {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = "https://pcsclite.apdu.fr/";
    changelog = "https://salsa.debian.org/rousseau/PCSC/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd3;
    mainProgram = "pcscd";
    pkgConfigModules = [ "libpcsclite" ];
    platforms = lib.platforms.unix;
  };
})
