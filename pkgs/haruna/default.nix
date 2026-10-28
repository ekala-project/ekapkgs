{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ffmpeg-headless ? null,
  kdsingleapplication,
  libass,
  kdePackages,
  pkg-config,
  python3,
  qt6,
  yt-dlp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "haruna";
  version = "1.8.1";

  src = fetchFromGitLab {
    owner = "multimedia";
    repo = "haruna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JIpaP9Tfw1+RhTqHmNoP7tsSHfELxw7bJBk8oLq6iYQ=";
    domain = "invent.kde.org";
  };

  postPatch = ''
    substituteInPlace src/application.cpp \
      --replace '"yt-dlp"' '"${lib.getExe yt-dlp}"'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    kdePackages.extra-cmake-modules
    pkg-config
    python3.pkgs.setuptools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.breeze-icons
    kdePackages.qqc2-desktop-style
    yt-dlp
    ffmpeg-headless
    kdsingleapplication
    libass
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kdeclarative
    kdePackages.kfilemetadata
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kio
    kdePackages.kirigami
    kdePackages.kxmlgui
    kdePackages.kdoctools
    kdePackages.mpvqt
    kdePackages.kitemmodels
    qt6.qtbase
  ];

  env.LANG = "C.UTF-8";

  meta = {
    homepage = "https://invent.kde.org/multimedia/haruna";
    description = "Open source video player built with Qt/QML and libmpv";
    license = with lib.licenses; [
      bsd3
      cc-by-40
      cc-by-sa-40
      cc0
      gpl2Plus
      gpl3Plus
      wtfpl
    ];
    mainProgram = "haruna";
  };
})
