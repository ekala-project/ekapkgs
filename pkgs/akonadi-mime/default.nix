{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  shared-mime-info,
  libxslt,
  akonadi,
  kio,
  kmime,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "akonadi-mime";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/akonadi-mime-${finalAttrs.version}.tar.xz";
    hash = "sha256-HyYMCZsB/17vy6PJ1wa37OF7JRpXGa+kPY9Aze8NqvU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
    shared-mime-info
    libxslt
  ];

  buildInputs = [
    qt6.qtbase
    akonadi
    kio
    kmime
  ];

  meta = {
    description = "Libraries and daemons to implement basic email handling";
    homepage = "https://invent.kde.org/pim/akonadi-mime";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
