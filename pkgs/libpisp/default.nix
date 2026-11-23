{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  boost,
  nlohmann_json,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpisp";
  version = "1.8.0-1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "libpisp";
    tag = "pios/${finalAttrs.version}";
    hash = "sha256-b5rtt/jYf5Y/xjp99QX0I8flKoolzNleb3jlbdufHSc=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  buildInputs = [
    boost
    nlohmann_json
  ];

  meta = {
    homepage = "https://github.com/raspberrypi/libpisp";
    description = "Helper library to generate run-time configuration for the Raspberry Pi ISP (PiSP), consisting of the Frontend and Backend hardware components";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
})
