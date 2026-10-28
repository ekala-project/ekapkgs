{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  breeze-icons,
  kcalendarcore,
  kidentitymanagement ? null, # TODO: not yet in ekapkgs
  ktexttemplate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcalutils";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kcalutils-${finalAttrs.version}.tar.xz";
    hash = "sha256-XlyocmeGfyA6X/2HyI4auXiEtm+B/05s6NDWwIegxFA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    breeze-icons
    kcalendarcore
    ktexttemplate
  ]
  ++ lib.optional (kidentitymanagement != null) kidentitymanagement;

  meta = {
    description = "Library providing utility functions for the handling of calendar data";
    homepage = "https://invent.kde.org/pim/kcalutils";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
