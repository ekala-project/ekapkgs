{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  kfilemetadata,
  ki18n,
  kiconthemes,
  kio,
  kparts,
  kpty,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
  libarchive,
  libzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ark";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ark-${finalAttrs.version}.tar.xz";
    hash = "sha256-7x5sR/sX5XJxkX9x1yzQk+7nyIvN9nl1OVhJja5tQ6A=";
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
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kfilemetadata
    ki18n
    kiconthemes
    kio
    kparts
    kpty
    kservice
    kwidgetsaddons
    kwindowsystem
    libarchive
    (libzip.override { withOpenssl = true; })
  ];

  meta = {
    description = "KDE archive manager";
    homepage = "https://apps.kde.org/ark/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ark";
  };
})
