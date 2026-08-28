{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  alsa-lib,
  acpid,
  bc,
  ddcutil,
  efl,
  libexif,
  pam,
  xkeyboard-config,
  udisks,
  bluetoothSupport ? true,
  bluez,
  pulseSupport ? true,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enlightenment";
  version = "0.27.1";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/enlightenment/enlightenment-${finalAttrs.version}.tar.xz";
    hash = "sha256-tB34dx9g47lqGXOuVm10JcU6gznxjlTjEjAhh4HaL6k=";
  };

  nativeBuildInputs = [
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    acpid
    bc
    ddcutil
    efl
    libexif
    pam
    xkeyboard-config
    udisks
  ]
  ++ lib.optional bluetoothSupport bluez
  ++ lib.optional pulseSupport libpulseaudio;

  patches = [
    ./0001-wrapped-setuid-executables.patch
    ./0003-setuid-missing-path.patch
  ];

  postPatch = ''
    substituteInPlace src/modules/everything/evry_plug_calc.c \
      --replace "ecore_exe_pipe_run(\"bc -l\"" "ecore_exe_pipe_run(\"${bc}/bin/bc -l\""
  '';

  mesonBuildType = "release";

  mesonFlags = [
    "-D systemdunitdir=lib/systemd/user"
  ];

  passthru.providedSessions = [ "enlightenment" ];

  meta = {
    description = "Compositing Window Manager and Desktop Shell";
    homepage = "https://www.enlightenment.org";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
