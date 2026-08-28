{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  udev,
  libcec_platform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcec";
  version = "8.1.6";

  src = fetchFromGitHub {
    owner = "Pulse-Eight";
    repo = "libcec";
    rev = "libcec-${finalAttrs.version}";
    sha256 = "sha256-56hzVLPj50y0GdGzmaUEWF6KLX7nWKNWTG7jnt85UpQ=";
  };

  # Fix dlopen path
  postPatch = ''
    substituteInPlace include/cecloader.h --replace "\"libcec." "\"$out/lib/libcec."
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    libcec_platform
    udev
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=1"
    "-DHAVE_LINUX_API=1"
  ];

  meta = {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = "http://libcec.pulse-eight.com";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
