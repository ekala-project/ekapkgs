{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  ki18n,
  kparts,
  kwindowsystem,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kontactinterface";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kontactinterface-${finalAttrs.version}.tar.xz";
    hash = "sha256-wxip6u+d+PPjvOUV9DecUoQlX3sstCSVCufMX/+Z7KM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kcoreaddons
    ki18n
    kparts
    kwindowsystem
    kxmlgui
  ];

  meta = {
    description = "Kontact plugin interface library";
    homepage = "https://invent.kde.org/pim/kontactinterface";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
