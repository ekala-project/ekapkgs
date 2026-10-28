{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  ki18n,
  kitemmodels,
  kservice,
  ksvg,
  kwayland ? null, # TODO: not yet in ekapkgs
  kwindowsystem,
  libplasma ? null, # TODO: not yet in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-nano";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-nano-${finalAttrs.version}.tar.xz";
    hash = "sha256-mlNW9lJtrsCHPI3TXZjYgSLCvHc562n7lYUUamdy8gI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    kconfig
    kcoreaddons
    ki18n
    kitemmodels
    kservice
    ksvg
    kwindowsystem
  ]
  ++ lib.optional (kwayland != null) kwayland
  ++ lib.optional (libplasma != null) libplasma;

  meta = {
    description = "A minimal Plasma shell package";
    homepage = "https://invent.kde.org/plasma/plasma-nano";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
