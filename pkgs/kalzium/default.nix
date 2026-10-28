{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  ocaml,
  karchive,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kio,
  kitemviews,
  knewstuff,
  kplotting,
  ktextwidgets,
  kunitconversion,
  kwidgetsaddons,
  kxmlgui,
  eigen,
  openbabel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kalzium";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kalzium-${finalAttrs.version}.tar.xz";
    hash = "sha256-zByzfvJ+jivD4R61EmC4fgXPDcN3VM+Yssu1ntB+Za8=";
  };

  # FIXME: look into how to make it find libfacile
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
    pkg-config
    ocaml
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtscxml
    karchive
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kio
    kitemviews
    knewstuff
    kplotting
    ktextwidgets
    kunitconversion
    kwidgetsaddons
    kxmlgui
    eigen
    openbabel
  ];

  meta = {
    description = "Periodic Table of Elements";
    homepage = "https://apps.kde.org/kalzium/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kalzium";
  };
})
