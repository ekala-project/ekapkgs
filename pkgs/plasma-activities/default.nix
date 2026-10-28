{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  kwindowsystem,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-activities";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-activities-${finalAttrs.version}.tar.xz";
    hash = "sha256-2T8xtvM3M604AwmPT2IuVePvUstc2X5iGnuAPm8OP3w=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kconfig
    kcoreaddons
    kwindowsystem
    boost
  ];

  meta = {
    description = "Core components for the KDE's Activities System";
    homepage = "https://invent.kde.org/plasma/plasma-activities";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "plasma-activities-cli6";
  };
})
