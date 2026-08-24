{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hidapi";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "hidapi";
    rev = "hidapi-${finalAttrs.version}";
    sha256 = "sha256-o6IZRG42kTa7EQib9eaV1HGyjaGgeCabk+8fyQTm/0s=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libusb1
    udev
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Library for communicating with USB and Bluetooth HID devices";
    homepage = "https://github.com/libusb/hidapi";
    maintainers = [ ];
    license = with lib.licenses; [
      bsd3
      gpl3Only
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
