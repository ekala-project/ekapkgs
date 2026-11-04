{
  lib,
  stdenv,
  fetchurl,
  cmake,
  docbook-xml-dtd,
  docbook_xsl,
  doxygen,
  pkg-config,
  qt6,
  alsa-lib,
  fluidsynth,
  libpulseaudio,
  sonivox,
}:

stdenv.mkDerivation rec {
  pname = "drumstick";
  version = "2.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/drumstick-${version}.tar.bz2";
    hash = "sha256-fVN67Kd0hvyPV6hK898b0N3dtAGmGTXotIIVQtFgtnc=";
  };

  patches = [ ./drumstick-plugins.patch ];

  postPatch = ''
    substituteInPlace library/rt/backendmanager.cpp --subst-var out
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    docbook-xml-dtd.v4_5
    docbook_xsl
    doxygen
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    fluidsynth
    libpulseaudio
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    sonivox
    qt6.qt5compat
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_DBUS" true)
    (lib.cmakeBool "USE_QT5" false)
  ];

  meta = {
    description = "MIDI libraries for Qt/C++";
    homepage = "https://drumstick.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
