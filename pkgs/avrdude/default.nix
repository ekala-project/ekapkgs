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
  version = "8.3";

  src = fetchFromGitHub {
    owner = "avrdudes";
    repo = "avrdude";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QE41ncnn8t55TYe7ypKYPjo9C2ioxuFXN3nFiYlvpEo=";
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
    platforms = lib.platforms.linux;
    mainProgram = "avrdude";
  };
})
