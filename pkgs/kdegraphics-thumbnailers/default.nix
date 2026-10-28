{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kio,
  libkdcraw,
  libkexiv2,
  kdegraphics-mobipocket ? null, # TODO: not yet in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdegraphics-thumbnailers";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kdegraphics-thumbnailers-${finalAttrs.version}.tar.xz";
    hash = "sha256-LRaQfWMLzlCxsHLy810MV3wXi3lNzIAURDEwy7Uu1ig=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    karchive
    kio
    libkdcraw
    libkexiv2
  ]
  ++ lib.optional (kdegraphics-mobipocket != null) kdegraphics-mobipocket;

  dontWrapQtApps = true;

  meta = {
    description = "Thumbnailers for various graphics file formats";
    homepage = "https://invent.kde.org/graphics/kdegraphics-thumbnailers";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
