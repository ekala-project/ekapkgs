{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcmutils,
  kcompletion,
  kconfig,
  kcoreaddons,
  kdesu,
  ki18n,
  kiconthemes,
  kio,
  kparts,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kde-cli-tools";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kde-cli-tools-${finalAttrs.version}.tar.xz";
    hash = "sha256-GPPEIbMFADyvc/np++wJ+/MPRy2+gf7DKARsyniDox0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kcmutils
    kcompletion
    kconfig
    kcoreaddons
    kdesu
    ki18n
    kiconthemes
    kio
    kparts
    kservice
    kwidgetsaddons
    kwindowsystem
  ];

  meta = {
    description = "KDE CLI tools";
    homepage = "https://invent.kde.org/plasma/kde-cli-tools";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
