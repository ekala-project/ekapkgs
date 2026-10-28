{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  plasma-activities,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-activities-stats";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-activities-stats-${finalAttrs.version}.tar.xz";
    hash = "sha256-mJY5binVhBx6D0KBTO0Bq1j8rUBqVS3e4slQ8gVUms8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kconfig
    plasma-activities
  ];

  dontWrapQtApps = true;

  meta = {
    description = "A library for accessing the usage data collected by the activities system";
    homepage = "https://invent.kde.org/plasma/plasma-activities-stats";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
