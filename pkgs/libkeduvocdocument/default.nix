{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  karchive,
  ki18n,
  kio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkeduvocdocument";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkeduvocdocument-${finalAttrs.version}.tar.xz";
    hash = "sha256-/JSMgE7MqxnUGK+v0lSd2ZoOwt3KyntxAl/Dujt3NJU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    karchive
    ki18n
    kio
  ];

  meta = {
    description = "Library to parse, convert, and manipulate KVTML files";
    homepage = "https://invent.kde.org/education/libkeduvocdocument";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
