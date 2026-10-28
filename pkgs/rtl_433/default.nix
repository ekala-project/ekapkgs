{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  rtl-sdr,
  soapysdr-with-plugins ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl_433";
  version = "25.12";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    tag = finalAttrs.version;
    hash = "sha256-VDNXLx6OUBQkflKFHp1LP8N5g15o6vYg3P9XWgIoYIg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    libusb1
    rtl-sdr
    soapysdr-with-plugins
  ];

  doCheck = true;

  meta = {
    description = "Decode traffic from devices that broadcast on 433.9 MHz, 868 MHz, 315 MHz, 345 MHz and 915 MHz";
    homepage = "https://github.com/merbanan/rtl_433";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "rtl_433";
  };
})
