{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  pkg-config,
  udev,
  libevdev,
  libgudev,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwacom";
  version = "2.19.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${finalAttrs.version}";
    hash = "sha256-BYfMltOBhb9iS2sTazibcdIaAq5WHecHJIHIfu/cUAQ=";
  };

  postPatch = ''
    patchShebangs test/check-files-in-git.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    python3
  ];

  buildInputs = [
    glib
    udev
    libevdev
    libgudev
  ];

  mesonFlags = [
    "-Dtests=disabled"
    (lib.mesonOption "sysconfdir" "/etc")
  ];

  doCheck = false;

  meta = {
    platforms = lib.platforms.linux;
    homepage = "https://linuxwacom.github.io/";
    changelog = "https://github.com/linuxwacom/libwacom/blob/${finalAttrs.src.rev}/NEWS";
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    license = lib.licenses.hpnd;
    maintainers = [ ];
  };
})
