{
  config,
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  glib,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  udev,
  pulseaudioSupport ? config.pulseaudio or true,
  libpulseaudio,
  ossSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmatemixer";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/libmatemixer-${finalAttrs.version}.tar.xz";
    sha256 = "XXO5Ijl/YGiOPJUw61MrzkbDDiYtsbU1L6MsQNhwoMc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    glib
  ]
  ++ lib.optionals alsaSupport [
    alsa-lib
    udev
  ]
  ++ lib.optionals pulseaudioSupport [
    libpulseaudio
  ];

  configureFlags = lib.optional ossSupport "--enable-oss";

  enableParallelBuilding = true;

  meta = {
    description = "Mixer library for MATE";
    homepage = "https://github.com/mate-desktop/libmatemixer";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
