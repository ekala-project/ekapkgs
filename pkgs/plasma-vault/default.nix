{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kio,
  kitemmodels,
  kpackage,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
  libksysguard ? null, # TODO: not yet in ekapkgs
  libplasma ? null, # TODO: not yet in ekapkgs
  networkmanager-qt,
  plasma-activities,
  solid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-vault";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-vault-${finalAttrs.version}.tar.xz";
    hash = "sha256-KiW7K9dcnZKJTT51oZsrywGtqpN5gFeflCLowd+E3aU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kio
    kitemmodels
    kpackage
    kservice
    kwidgetsaddons
    kwindowsystem
    networkmanager-qt
    plasma-activities
    solid
  ]
  ++ lib.optional (libksysguard != null) libksysguard
  ++ lib.optional (libplasma != null) libplasma;

  meta = {
    description = "Plasma applet and services for creating encrypted vaults";
    homepage = "https://invent.kde.org/plasma/plasma-vault";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
