{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  akonadi,
  akonadi-contacts ? null, # TODO: not yet in ekapkgs
  akonadi-mime,
  kcalendarcore,
  kcalutils,
  kcontacts,
  kcrash,
  kdbusaddons,
  kidentitymanagement ? null, # TODO: not yet in ekapkgs
  kmailtransport,
  knotifications,
  messagelib ? null, # TODO: not yet in ekapkgs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "akonadi-calendar";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/akonadi-calendar-${finalAttrs.version}.tar.xz";
    hash = "sha256-7+DAlJCKT+vpOf9clvsZHPJR04ITFBCLXrz91IjANGs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    akonadi
    akonadi-mime
    kcalendarcore
    kcalutils
    kcontacts
    kcrash
    kdbusaddons
    kmailtransport
    knotifications
  ]
  ++ lib.optional (akonadi-contacts != null) akonadi-contacts
  ++ lib.optional (kidentitymanagement != null) kidentitymanagement
  ++ lib.optional (messagelib != null) messagelib;

  meta = {
    description = "Akonadi calendar integration";
    homepage = "https://invent.kde.org/pim/akonadi-calendar";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kalendarac";
  };
})
