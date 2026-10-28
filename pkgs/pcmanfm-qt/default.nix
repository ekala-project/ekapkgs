{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  layer-shell-qt,
  libexif,
  libfm-qt,
  lxqt-build-tools,
  lxqt-menu-data ? null,
  menu-cache,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcmanfm-qt";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "pcmanfm-qt";
    tag = finalAttrs.version;
    hash = "sha256-c3DLzaTcdfWWnsjrYV552zNAHIfE/oF3mmQ73kjQXA0=";
  };

  postPatch = ''
    substituteInPlace config/pcmanfm-qt/lxqt/settings.conf.in --replace-fail @LXQT_SHARE_DIR@ /run/current-system/sw/share/lxqt
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    layer-shell-qt
    libexif
    libfm-qt
    lxqt-menu-data
    menu-cache
    qt6.qtbase
    qt6.qtimageformats # add-on module to support more image file formats
    qt6.qtwayland
    qt6.qtsvg
  ];

  meta = {
    homepage = "https://github.com/lxqt/pcmanfm-qt";
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    mainProgram = "pcmanfm-qt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
