{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  cups,
  kauth,
  kcodecs,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdeclarative ? null, # TODO: not yet in ekapkgs
  ki18n,
  kiconthemes,
  kio,
  kirigami,
  kitemviews,
  kjobwidgets,
  knotifications,
  kservice,
  kstatusnotifieritem,
  kwayland ? null, # TODO: not yet in ekapkgs
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  plasma-workspace ? null, # TODO: not yet in ekapkgs
  solid,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-kde";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/xdg-desktop-portal-kde-${finalAttrs.version}.tar.xz";
    hash = "sha256-Xr7cPc9QjoXy97vd/6LMpoBWUP/h3ONQxKHfxdLwfFA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    cups
    kauth
    kcodecs
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kiconthemes
    kio
    kirigami
    kitemviews
    kjobwidgets
    knotifications
    kservice
    kstatusnotifieritem
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    solid
    wayland
    wayland-protocols
  ]
  ++ lib.optional (kdeclarative != null) kdeclarative
  ++ lib.optional (kwayland != null) kwayland
  ++ lib.optional (plasma-workspace != null) plasma-workspace;

  meta = {
    description = "A backend implementation for xdg-desktop-portal using Qt/KDE Frameworks";
    homepage = "https://invent.kde.org/plasma/xdg-desktop-portal-kde";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
