{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  replaceVars,
  sshfs,
  kcmutils,
  kconfig,
  kcontacts,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kio,
  kirigami,
  kirigami-addons,
  kitemmodels,
  knotifications,
  kpackage,
  kservice,
  kstatusnotifieritem,
  kwindowsystem,
  plasma-wayland-protocols,
  qqc2-desktop-style,
  solid,
  wayland,
  wayland-protocols,
  libei,
  libevdev,
  libfakekey,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdeconnect-kde";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kdeconnect-kde-${finalAttrs.version}.tar.xz";
    hash = "sha256-79nVje6mhX8Y0Md8i8aBkoOag+TUpRj8gppyVFmj26U=";
  };

  patches = [
    (replaceVars ../../kde/gear/kdeconnect-kde/hardcode-sshfs-path.patch {
      sshfs = lib.getExe sshfs;
    })

    # backport fixes for udev rule install path
    (fetchpatch {
      url = "https://invent.kde.org/network/kdeconnect-kde/-/commit/a0d71485a540270421261e05cbe9102a0031ec34.diff";
      hash = "sha256-Klfz3a4AfUMNGWqk/E8xqRvqg7Wn0PrB9+aYmUHoNGM=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/network/kdeconnect-kde/-/commit/e00d56efce0409a4a7905f7f105d06d5c96031d0.diff";
      hash = "sha256-nRaQSR/jKHgaiSmrJaYNqSI0Hd2QmtwHWUZY8TeL/2Y=";
    })
  ];

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${sshfs}" > $out/nix-support/depends
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtconnectivity
    qt6.qtmultimedia
    kcmutils
    kconfig
    kcontacts
    kcoreaddons
    kdbusaddons
    ki18n
    kiconthemes
    kio
    kirigami
    kirigami-addons
    kitemmodels
    knotifications
    kpackage
    kservice
    kstatusnotifieritem
    kwindowsystem
    plasma-wayland-protocols
    qqc2-desktop-style
    solid
    wayland
    wayland-protocols
    libei
    libevdev
    libfakekey
    kdePackages.kpeople
    kdePackages.modemmanager-qt
    kdePackages.pulseaudio-qt
  ];

  cmakeEntries = {
    QtWaylandScanner_EXECUTABLE = "${qt6.qtbase}/libexec/qtwaylandscanner";
  };

  meta = {
    description = "Multi-platform app that allows your devices to communicate";
    homepage = "https://apps.kde.org/kdeconnect-kde/";
    license = with lib.licenses; [
      asl20
      bsd2
      bsd3
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus
      lgpl21Only
      lgpl3Only
      mit
    ];
    platforms = lib.platforms.linux;
    mainProgram = "kdeconnect-cli";
  };
})
