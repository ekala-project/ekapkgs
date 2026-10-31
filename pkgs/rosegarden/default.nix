{
  lib,
  stdenv,
  fetchurl,
  cmake,
  makedepend,
  perl,
  pkg-config,
  qt5,
  alsa-lib,
  dssi,
  fftwSinglePrec,
  flac,
  glib,
  ladspa-header,
  ladspaPlugins,
  libjack2,
  liblo,
  libmpg123,
  libopus,
  libsamplerate,
  libsndfile,
  libsysprof-capture,
  libvorbis,
  lilv,
  lv2,
  lirc,
  lrdf,
  libogg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rosegarden";
  version = "26.06";

  src = fetchurl {
    url = "mirror://sourceforge/rosegarden/rosegarden-${finalAttrs.version}.tar.xz";
    hash = "sha256-ddnwHGqkbRoIwawp7jdeSqsdzbZw+3IwqeacCUWNO9k=";
  };

  postPhase = ''
    substituteInPlace src/CMakeLists.txt --replace svnheader svnversion
  '';

  nativeBuildInputs = [
    cmake
    makedepend
    perl
    pkg-config
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    dssi
    fftwSinglePrec
    flac
    glib
    ladspa-header
    ladspaPlugins
    libjack2
    liblo
    libmpg123
    libogg
    libopus
    libsamplerate
    libsndfile
    libsysprof-capture
    libvorbis
    lilv
    lv2
    lirc
    lrdf
    qt5.qtbase
  ];

  cmakeFlags = [
    "-DLILV_INCLUDE_DIR=${lilv.dev}/include/lilv-0"
  ];

  meta = {
    homepage = "https://www.rosegardenmusic.com/";
    description = "Music composition and editing environment";
    mainProgram = "rosegarden";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
