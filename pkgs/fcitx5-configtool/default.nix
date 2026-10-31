{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  pkg-config,
  fcitx5,
  fcitx5-qt,
  isocodes,
  xkeyboard-config,
  libxkbfile,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-configtool";
  version = "5.1.16";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-d+BQgULy6X3GP5/DqQtY+QzNPYyKy8z1N1yiw7jaicY=";
  };

  cmakeFlags = [
    (lib.cmakeBool "KDE_INSTALL_USE_QT_SYS_PATHS" true)
    (lib.cmakeBool "ENABLE_KCM" false)
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    kdePackages.extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    fcitx5
    fcitx5-qt
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    kdePackages.kitemviews
    kdePackages.kwidgetsaddons
    isocodes
    xkeyboard-config
    libxkbfile
  ];

  meta = {
    description = "Configuration Tool for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-configtool";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "fcitx5-config-qt";
  };
}
