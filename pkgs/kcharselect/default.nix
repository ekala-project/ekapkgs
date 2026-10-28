{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kbookmarks,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcharselect";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kcharselect-${finalAttrs.version}.tar.xz";
    hash = "sha256-zlApmhEfim40alLL9l13yQ2ZH7lMUhmhnTOeF6az+ps=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kbookmarks
    kcoreaddons
    kcrash
    ki18n
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "Tool to select and copy special characters from all installed fonts";
    homepage = "https://apps.kde.org/kcharselect/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kcharselect";
  };
})
