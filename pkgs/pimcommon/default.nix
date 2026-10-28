{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  libxslt,
  akonadi,
  akonadi-contacts ? null, # TODO: not yet in ekapkgs
  akonadi-search,
  kcalendarcore,
  kcmutils,
  kcolorscheme,
  kconfig,
  kcontacts,
  kcrash,
  kdbusaddons,
  kdoctools,
  kguiaddons,
  ki18n,
  kiconthemes,
  kimap,
  kio,
  kitemviews,
  kjobwidgets,
  kldap ? null, # TODO: not yet in ekapkgs
  knotifications,
  knotifyconfig,
  kparts,
  kservice,
  ktextaddons,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  libkdepim,
  plasma-activities,
  purpose,
  sonnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pimcommon";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/pimcommon-${finalAttrs.version}.tar.xz";
    hash = "sha256-uTln4NGYiTtfz4qQ52rmPEZdhhPuG0UprJQlIWw28V4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
    libxslt
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    akonadi
    akonadi-search
    kcalendarcore
    kcmutils
    kcolorscheme
    kconfig
    kcontacts
    kcrash
    kdbusaddons
    kdoctools
    kguiaddons
    ki18n
    kiconthemes
    kimap
    kio
    kitemviews
    kjobwidgets
    knotifications
    knotifyconfig
    kparts
    kservice
    ktextaddons
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    libkdepim
    plasma-activities
    purpose
    sonnet
  ]
  ++ lib.optional (akonadi-contacts != null) akonadi-contacts
  ++ lib.optional (kldap != null) kldap;

  meta = {
    description = "Common libraries for KDE PIM";
    homepage = "https://invent.kde.org/pim/pimcommon";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
