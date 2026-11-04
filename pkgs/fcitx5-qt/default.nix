{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  fcitx5,
  gettext,
  qt6,
  wayland,
}:
let
  majorVersion = lib.versions.major qt6.qtbase.version;
in
stdenv.mkDerivation rec {
  pname = "fcitx5-qt${majorVersion}";
  version = "5.1.15";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-qt";
    rev = version;
    hash = "sha256-xmtFiWjjknDNN0RdI45GwiuBojRCRZiSGxP9asE5OeY=";
  };

  postPatch = ''
    substituteInPlace qt${majorVersion}/platforminputcontext/CMakeLists.txt \
      --replace \$"{CMAKE_INSTALL_QT${majorVersion}PLUGINDIR}" $out/${qt6.qtbase.qtPluginPrefix}
  '';

  cmakeFlags = [
    "-DENABLE_QT4=OFF"
    "-DENABLE_QT5=OFF"
    "-DENABLE_QT6=OFF"
    "-DENABLE_QT${majorVersion}=ON"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    kdePackages.extra-cmake-modules
    gettext
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    fcitx5
    wayland
  ];

  meta = {
    description = "Fcitx5 Qt Library";
    homepage = "https://github.com/fcitx/fcitx5-qt";
    license = with lib.licenses; [
      lgpl21Plus
      bsd3
    ];
    platforms = lib.platforms.linux;
  };
}
