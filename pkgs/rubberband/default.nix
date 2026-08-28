{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsamplerate,
  libsndfile,
  fftw,
  lv2,
  vamp-plugin-sdk,
  ladspa-header,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rubberband";
  version = "4.0.0";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/rubberband-${finalAttrs.version}.tar.bz2";
    hash = "sha256-rwUDE+5jvBizWy4GTl3OBbJ2qvbRqiuKgs7R/i+AKOk=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  buildInputs = [
    libsamplerate
    libsndfile
    fftw
    vamp-plugin-sdk
    ladspa-header
    lv2
  ];

  mesonFlags = [
    "-Dtests=disabled"
    "-Djni=disabled"
  ];

  meta = {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = "https://breakfastquay.com/rubberband/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
