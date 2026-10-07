{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stlink";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "stlink-org";
    repo = "stlink";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-RtblGRTRenJVC9HHKDbLtNZpzikVZvwDzXjKCQXxLTs=";
  };

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DSTLINK_MODPROBED_DIR=${placeholder "out"}/etc/modprobe.d"
    "-DSTLINK_UDEV_RULES_DIR=${placeholder "out"}/lib/udev/rules.d"
  ];

  meta = {
    description = "In-circuit debug and programming for ST-Link devices";
    homepage = "https://github.com/stlink-org/stlink";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})
