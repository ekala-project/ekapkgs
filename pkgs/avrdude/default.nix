{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
  pkg-config,
  libusb1,
  elfutils,
  libftdi1,
  readline,
  hidapi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avrdude";
  version = "8.1";

  src = fetchFromGitHub {
    owner = "avrdudes";
    repo = "avrdude";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-i1q0NQKVd/wiOm1Amop3hW+FWuefFOQCCivuEtEH38k=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    elfutils
    hidapi
    libusb1
    libftdi1
    readline
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "-DHAVE_LINUXSPI=ON"
    "-DHAVE_PARPORT=ON"
  ];

  meta = {
    description = "Command-line tool for programming Atmel AVR microcontrollers";
    homepage = "https://www.nongnu.org/avrdude/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "avrdude";
  };
})
