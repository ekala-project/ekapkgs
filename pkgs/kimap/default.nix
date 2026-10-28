{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  cyrus_sasl,
  kcoreaddons,
  ki18n,
  kio,
  kmime,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kimap";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kimap-${finalAttrs.version}.tar.xz";
    hash = "sha256-cxX8sMCyEydTeCKbezGkI5rNOY/79o/UlMs6pmKlHpE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    cyrus_sasl
    kcoreaddons
    ki18n
    kio
    kmime
  ];

  meta = {
    description = "Job-based API for interacting with IMAP servers";
    homepage = "https://invent.kde.org/pim/kimap";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
