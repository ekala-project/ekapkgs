{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  cmake,
  cfitsio,
  libusb1,
  kmod,
  zlib,
  boost,
  libev,
  libnova,
  curl,
  libjpeg,
  gsl,
  fftw,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "indilib";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y2JmlboNU7e2Whvv6snd8Qgotr+AAkUkAd9qCORZoI0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    curl
    cfitsio
    libev
    libusb1
    zlib
    boost
    libnova
    libjpeg
    gsl
    fftw
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for f in $out/lib/udev/rules.d/*.rules
    do
      substituteInPlace $f --replace-warn "/bin/sh" "${bash}/bin/sh" \
                           --replace-quiet "/sbin/modprobe" "${kmod}/sbin/modprobe"
    done
  '';

  meta = {
    homepage = "https://www.indilib.org/";
    description = "Implementation of the INDI protocol for POSIX operating systems";
    changelog = "https://github.com/indilib/indi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
