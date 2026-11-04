{
  lib,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  ffmpeg,
  openal-soft,
  stdenv,
  qt6,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "subtitlecomposer";
  version = "0.8.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "multimedia";
    repo = "subtitlecomposer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zGbI960NerlOEUvhOLm+lEJdbhj8VFUfm8pkOYGRcGw=";
  };

  cmakeEntries = {
    QT_MAJOR_VERSION = 6;
    QT_FIND_PRIVATE_MODULES = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    kdePackages.extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg
    openal-soft
    qt6.qt5compat
  ]
  ++ (with kdePackages; [
    kcodecs
    kconfig
    kconfigwidgets
    kcoreaddons
    ki18n
    kio
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    sonnet
  ]);

  meta = {
    homepage = "https://apps.kde.org/subtitlecomposer";
    description = "Open source text-based subtitle editor";
    license = lib.licenses.gpl2Plus;
    mainProgram = "subtitlecomposer";
    platforms = lib.platforms.linux;
  };
})
