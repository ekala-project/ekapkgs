{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcodecs,
  kcoreaddons,
  ki18n,
  poppler,
  taglib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kfilemetadata";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kfilemetadata-6.30.0.tar.xz";
    hash = "sha256-XhTNjjleknBCyz63z/R+Dv/aXovyUgzxjRCCqUA7LmI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    poppler
    taglib
  ];

  propagatedBuildInputs = [
    karchive
    kcodecs
    kcoreaddons
    ki18n
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE library for extracting file metadata";
    homepage = "https://invent.kde.org/frameworks/kfilemetadata";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
