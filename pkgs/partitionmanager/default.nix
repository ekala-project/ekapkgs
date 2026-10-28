{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kio,
  kjobwidgets,
  kpmcore,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "partitionmanager";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/partitionmanager-${finalAttrs.version}.tar.xz";
    hash = "sha256-GfLjj3mCuLWm2+fjCIxw+I4fnKCJrEsJthW3DUpMcpI=";
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
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kio
    kjobwidgets
    kpmcore
    kwidgetsaddons
    kxmlgui
  ];

  propagatedUserEnvPkgs = [ kpmcore ];

  passthru = {
    inherit kpmcore;
  };

  meta = {
    description = "Manage the disk devices, partitions and file systems on your computer";
    homepage = "https://invent.kde.org/system/partitionmanager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "partitionmanager";
  };
})
