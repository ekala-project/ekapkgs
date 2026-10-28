{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kauth,
  kcmutils,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kio,
  kservice,
  kstatusnotifieritem,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwalletmanager";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kwalletmanager-${finalAttrs.version}.tar.xz";
    hash = "sha256-V5z5DJ1umqn/EDdHIIxmoXLvzzM4pfDXOE5jx54Xtmo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    karchive
    kauth
    kcmutils
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kio
    kservice
    kstatusnotifieritem
    kwallet
    kwidgetsaddons
    kwindowsystem
    kxmlgui
  ];

  meta = {
    description = "Tool to manage the passwords on your system";
    homepage = "https://apps.kde.org/kwalletmanager5/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kwalletmanager5";
  };
})
