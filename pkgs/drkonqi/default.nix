{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kconfig,
  kcoreaddons,
  kcrash,
  ki18n,
  kidletime,
  kio,
  kitemmodels,
  knotifications,
  kservice,
  kstatusnotifieritem,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  solid,
  syntax-highlighting,
  systemd,
  elfutils,
  gdb,
  python3,
}:

let
  gdb' = gdb.override {
    hostCpuOnly = true;
    python3 = python3.withPackages (ps: [
      ps.psutil
      ps.pygdbmi
      ps.sentry-sdk
    ]);
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "drkonqi";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/drkonqi-${finalAttrs.version}.tar.xz";
    hash = "sha256-nQK5vYU0rJjbt3pzJIESZU4t7jqxzzzFnmm6eAJ6tCM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kconfig
    kcoreaddons
    kcrash
    ki18n
    kidletime
    kio
    kitemmodels
    knotifications
    kservice
    kstatusnotifieritem
    kwallet
    kwidgetsaddons
    kwindowsystem
    solid
    syntax-highlighting
    systemd
  ];

  cmakeEntries = {
    WITH_GDB12 = true;
    WITH_PYTHON_VENDORING = false;
  };

  # Hardcoded as QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${gdb'}" > $out/nix-support/depends
  '';

  meta = {
    description = "Crash handler for KDE software";
    homepage = "https://invent.kde.org/plasma/drkonqi";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
