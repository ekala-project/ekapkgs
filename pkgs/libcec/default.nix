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
  version = "8.1.7";

  src = fetchFromGitHub {
    owner = "Pulse-Eight";
    repo = "libcec";
    rev = "libcec-${finalAttrs.version}";
    sha256 = "sha256-teh4w6pDn0HJ9W0FnqhnMYFBd6JxgK9QYfVqYHXviiI=";
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

  cmakeEntries = {
    BUILD_SHARED_LIBS = true;
    HAVE_LINUX_API = true;
  };

  meta = {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = "http://libcec.pulse-eight.com";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
