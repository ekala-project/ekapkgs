{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  kcolorscheme,
  kconfig,
  kconfigwidgets,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  kitemviews,
  knewstuff,
  knotifications,
  kpackage,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frameworkintegration";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/frameworkintegration-${finalAttrs.version}.tar.xz";
    hash = "sha256-gXxJsvarv+Yk4y+aIf/Kx+324EhqCIMFChRB4v7zyTI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    kcolorscheme
    kconfig
    kconfigwidgets
    kguiaddons
    ki18n
    kiconthemes
    kio
    kitemviews
    knewstuff
    knotifications
    kpackage
    kwidgetsaddons
    # packagekit-qt and appstream-qt are optional; not yet available
    # oxygen-icons is optional
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Framework providing components to allow applications to integrate with a KDE Workspace";
    homepage = "https://invent.kde.org/frameworks/frameworkintegration";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
