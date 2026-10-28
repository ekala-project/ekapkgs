{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  kconfig,
  kcrash,
  kdbusaddons,
  ki18n,
  kirigami-addons,
  knewstuff,
  libkeduvocdocument,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwordquiz";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kwordquiz-${finalAttrs.version}.tar.xz";
    hash = "sha256-ralgw0dPfJCd4E0gYFzJcOmsMX4AohWgY0mOT7I80Ig=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtmultimedia
    kconfig
    kcrash
    kdbusaddons
    ki18n
    kirigami-addons
    knewstuff
    libkeduvocdocument
  ];

  meta = {
    description = "Flash Card Trainer";
    homepage = "https://apps.kde.org/kwordquiz/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kwordquiz";
  };
})
