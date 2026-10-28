{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcrash,
  kdoctools,
  ki18n,
  kiconthemes,
  knotifications,
  knotifyconfig,
  kstatusnotifieritem,
  ktextwidgets,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kteatime";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kteatime-${finalAttrs.version}.tar.xz";
    hash = "sha256-YQ7RGLOnQxP7EsSmOVALzBU8I5+/p7v1ZOd2cNJnAfg=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kcrash
    ki18n
    kiconthemes
    knotifications
    knotifyconfig
    kstatusnotifieritem
    ktextwidgets
    kxmlgui
  ];

  meta = {
    description = "Handy timer for steeping tea";
    homepage = "https://apps.kde.org/kteatime/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kteatime";
  };
})
