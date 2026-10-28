{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kcoreaddons,
  kcrash,
  kio,
  libksysguard ? null, # TODO: not yet in ekapkgs
  networkmanager-qt,
  solid,
  lm_sensors,
  libnl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksystemstats";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/ksystemstats-${finalAttrs.version}.tar.xz";
    hash = "sha256-J8+5oYkkS4l64j86hoHnxLRcxn7Cf6/4lheD7c4W8fw=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    kcoreaddons
    kcrash
    kio
    networkmanager-qt
    solid
    lm_sensors
    libnl
  ]
  ++ lib.optional (libksysguard != null) libksysguard;

  cmakeEntries = {
    SYSTEMSTATS_DBUS_INTERFACE = lib.optionalString (
      libksysguard != null
    ) "${libksysguard}/share/dbus-1/interfaces/org.kde.ksystemstats1.xml";
  };

  dontWrapQtApps = true;

  meta = {
    description = "A plugin based system monitoring daemon";
    homepage = "https://invent.kde.org/plasma/ksystemstats";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
