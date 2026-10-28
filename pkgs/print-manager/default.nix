{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcmutils,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdbusaddons,
  kdeclarative ? null, # TODO: not yet in ekapkgs
  ki18n,
  kio,
  kirigami,
  kitemmodels,
  knotifications,
  kwidgetsaddons,
  kwindowsystem,
  libplasma ? null, # TODO: not yet in ekapkgs
  cups,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "print-manager";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/print-manager-${finalAttrs.version}.tar.xz";
    hash = "sha256-8WWDkKcQTyuAYXbxiOo48UjnkAy5KLTd/K4GFq9S9s4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kcmutils
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    ki18n
    kio
    kirigami
    kitemmodels
    knotifications
    kwidgetsaddons
    kwindowsystem
    cups
  ]
  ++ lib.optional (kdeclarative != null) kdeclarative
  ++ lib.optional (libplasma != null) libplasma;

  meta = {
    description = "A tool for managing print jobs and printers";
    homepage = "https://invent.kde.org/plasma/print-manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
