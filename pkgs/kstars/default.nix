{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  cfitsio,
  curl,
  eigen,
  gsl,
  indi-full ? null,
  kdePackages,
  libnova,
  libraw,
  libsecret,
  libxisf,
  opencv,
  python3,
  stellarsolver,
  wcslib,
  xplanet,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kstars";
  version = "3.8.5";

  src = fetchurl {
    url = "mirror://kde/stable/kstars/${finalAttrs.version}/kstars-${finalAttrs.version}.tar.xz";
    hash = "sha256-GPV4lEv7qAD3CRrvg1UNiY4MNr3f4pafe7h4B99g5bM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    kdePackages.extra-cmake-modules
    kdePackages.kdoctools
    kdePackages.wrapQtAppsHook
    pkg-config
    python3.pkgs.setuptools
  ];

  buildInputs = [
    kdePackages.breeze-icons
    cfitsio
    curl
    eigen
    gsl
    indi-full
    kdePackages.kconfig
    kdePackages.kdoctools
    kdePackages.kguiaddons
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kio
    kdePackages.knewstuff
    kdePackages.knotifyconfig
    kdePackages.kplotting
    kdePackages.kwidgetsaddons
    kdePackages.kxmlgui
    libnova
    libraw
    libsecret
    libxisf
    opencv
    kdePackages.qtdatavis3d
    kdePackages.qtkeychain
    kdePackages.qtsvg
    kdePackages.qtwayland
    kdePackages.qtwebsockets
    stellarsolver
    wcslib
    xplanet
    zlib
  ];

  cmakeEntries = {
    BUILD_WITH_QT6 = true;
    XPLANET_PREFIX = "${xplanet}";
  }
  // lib.optionalAttrs (indi-full != null) {
    INDI_PREFIX = "${indi-full}";
  };

  cmakeFlags = [
    "-DDATA_INSTALL_DIR=$(out)/share/kstars/"
  ];

  meta = {
    description = "Virtual planetarium astronomy software";
    mainProgram = "kstars";
    homepage = "https://kde.org/applications/education/org.kde.kstars";
    longDescription = ''
      It provides an accurate graphical simulation of the night sky, from any location on Earth, at any date and time.
      The display includes up to 100 million stars, 13.000 deep-sky objects, all 8 planets, the Sun and Moon, and thousands of comets, asteroids, supernovae, and satellites.
      For students and teachers, it supports adjustable simulation speeds in order to view phenomena that happen over long timescales, the KStars Astrocalculator to predict conjunctions, and many common astronomical calculations.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
