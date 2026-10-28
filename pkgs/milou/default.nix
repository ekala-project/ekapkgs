{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  ki18n,
  krunner ? null, # TODO: not yet in ekapkgs
  libplasma ? null, # TODO: not yet in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "milou";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/milou-${finalAttrs.version}.tar.xz";
    hash = "sha256-tDx8t2UQmpGtnvfVhWxFhLOANJg3uvY8zKS0WmeSWrU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    ki18n
  ]
  ++ lib.optional (krunner != null) krunner
  ++ lib.optional (libplasma != null) libplasma;

  meta = {
    description = "A dedicated search application built on top of Baloo";
    homepage = "https://invent.kde.org/plasma/milou";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
