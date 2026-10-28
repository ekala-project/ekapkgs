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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksmtp";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ksmtp-${finalAttrs.version}.tar.xz";
    hash = "sha256-jZSIFbvNf09cPxnjFlESTjZ3HfGcK9EM1odjAj0kseU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    cyrus_sasl
    kcoreaddons
    ki18n
    kio
  ];

  meta = {
    description = "Job-based library to send email through an SMTP server";
    homepage = "https://invent.kde.org/pim/ksmtp";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
