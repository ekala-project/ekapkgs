{
  lib,
  stdenv,
  autoconf-archive,
  autoreconfHook,
  fetchFromGitHub,
  gettext,
  libnl,
  ncurses,
  pciutils,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powertop";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "fenrus75";
    repo = "powertop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-53jfqt0dtMqMj3W3m6ravUTzApLQcljDHfdXejeZa4M=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gettext
    libnl
    ncurses
    pciutils
    zlib
  ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace-fail "/sbin/modprobe" "modprobe"
    substituteInPlace src/tuning/bluetooth.cpp --replace-fail "/usr/bin/hcitool" "hcitool"
  '';

  meta = {
    homepage = "https://github.com/fenrus75/powertop";
    description = "Analyze power consumption on Intel-based laptops";
    mainProgram = "powertop";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
