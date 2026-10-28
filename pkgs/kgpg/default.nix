{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  gpgme,
  karchive,
  kcodecs,
  kconfigwidgets,
  kcontacts,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  kguiaddons,
  ki18n,
  kio,
  kjobwidgets,
  knotifications,
  kservice,
  kstatusnotifieritem,
  ktextwidgets,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kgpg";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kgpg-${finalAttrs.version}.tar.xz";
    hash = "sha256-MdnJjjU4gu/2uCGFcu7BkY9/tNHUts5ZWgLId749mFw=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    gpgme
    karchive
    kcodecs
    kconfigwidgets
    kcontacts
    kcoreaddons
    kcrash
    kdbusaddons
    kguiaddons
    ki18n
    kio
    kjobwidgets
    knotifications
    kservice
    kstatusnotifieritem
    ktextwidgets
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    kdePackages.akonadi-contacts
  ];

  meta = {
    description = "Simple interface for GnuPG, a powerful encryption utility";
    homepage = "https://apps.kde.org/kgpg/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kgpg";
  };
})
