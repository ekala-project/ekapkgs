{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  kconfig,
  kcrash,
  ki18n,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kbruch";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kbruch-${finalAttrs.version}.tar.xz";
    hash = "sha256-P/pWZ00TQ2QUxKUJe2Hr49rv2QGblx1HoCujzzZ9+h8=";
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
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "Practice Fractions";
    homepage = "https://apps.kde.org/kbruch/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kbruch";
  };
})
