{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  breeze-icons,
  kdoctools,
  ki18n,
  kiconthemes,
  knewstuff,
  ktexteditor,
  kuserfeedback,
  qtkeychain,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kate";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kate-${finalAttrs.version}.tar.xz";
    hash = "sha256-b60IAyNiMA2N5kbG1F8R2scsnHxt/qImHIRKQqF6hlI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    breeze-icons
    ki18n
    kiconthemes
    knewstuff
    ktexteditor
    kuserfeedback
    qtkeychain
  ];

  meta = {
    description = "KDE advanced text editor";
    homepage = "https://apps.kde.org/kate/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kate";
  };
})
