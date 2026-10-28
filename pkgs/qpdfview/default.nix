{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsForQt5,
  djvulibre,
  libspectre,
  cups,
  file,
  ghostscript,
  poppler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qpdfview";
  version = "0.5.0";

  src = fetchurl {
    url = "https://launchpad.net/qpdfview/trunk/${finalAttrs.version}/+download/qpdfview-0.5.tar.gz";
    hash = "sha256-RO/EQKRhy911eps5bxRh7novQ2ToHfVb0CIfkQIZvpk=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
    poppler
    djvulibre
    libspectre
    cups
    file
    ghostscript
  ];

  preConfigure = ''
    lrelease qpdfview.pro
    qmakeFlags+=(*.pro)
  '';

  qmakeFlags = [
    "TARGET_INSTALL_PATH=$(out)/bin"
    "PLUGIN_INSTALL_PATH=$(out)/lib/qpdfview"
    "DATA_INSTALL_PATH=$(out)/share/qpdfview"
    "MANUAL_INSTALL_PATH=$(out)/share/man/man1"
    "ICON_INSTALL_PATH=$(out)/share/icons/hicolor/scalable/apps"
    "LAUNCHER_INSTALL_PATH=$(out)/share/applications"
    "APPDATA_INSTALL_PATH=$(out)/share/appdata"
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-std=c++17";
  };

  meta = {
    description = "Tabbed document viewer";
    mainProgram = "qpdfview";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    homepage = "https://launchpad.net/qpdfview";
  };
})
