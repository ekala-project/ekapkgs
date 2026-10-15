{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  replaceVars,
  pkg-config,
  shared-mime-info,
  mlt,
  glaxnimate,
  ffmpeg,
  ffmpegthumbs,
  frei0r,
  opentimelineio,
  kddockwidgets,
  qqc2-desktop-style,
  libv4l,
  breeze-icons,
  karchive,
  kbookmarks,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  kitemviews,
  kjobwidgets,
  knewstuff,
  knotifications,
  kservice,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
  purpose,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdenlive";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/26.08.2/src/kdenlive-${finalAttrs.version}.tar.xz";
    hash = "sha256-EBnNojQppSbjotvdLsk0Bv7wyJyiQ68W36Fqya6Ka/g=";
  };

  patches = [
    (replaceVars ./dependency-paths.patch {
      inherit mlt glaxnimate;
      inherit ffmpeg;
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qtnetworkauth
    qt6.qtimageformats

    kddockwidgets
    qqc2-desktop-style

    ffmpeg
    ffmpegthumbs
    libv4l
    mlt
    opentimelineio

    breeze-icons
    karchive
    kbookmarks
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kguiaddons
    ki18n
    kiconthemes
    kio
    kitemviews
    kjobwidgets
    knewstuff
    knotifications
    kservice
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    purpose
  ];

  cmakeEntries = {
    BUILD_TESTING = false;
    FETCH_OTIO = 0;
    # breaks because our QML import paths are not set up at build time
    BUILD_RUN_QMLLINT = 0;
  };

  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
  ];

  meta = {
    description = "KDE non-linear video editor";
    homepage = "https://kdenlive.org/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "kdenlive";
    platforms = lib.platforms.unix;
  };
})
