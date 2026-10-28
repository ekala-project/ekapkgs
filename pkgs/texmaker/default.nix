{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  python3,
  qt6,
  poppler,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texmaker";
  version = "6.0.2";

  src = fetchurl {
    url = "https://www.xm1math.net/texmaker/texmaker-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Jey7FtFW7RUosxUR03ydp4WKLe8yi4fxf8h39X9ROc8=";
  };

  patches = [
    # Check if the patch can be removed next release
    ./fix-build-with-qt-6-10.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3.pkgs.setuptools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    poppler
    qt6.qtbase
    qt6.qtwebengine
    qt6.qt5compat
    qt6.qttools
    zlib
  ];

  qmakeFlags = [
    "DESKTOPDIR=$(out)/share/applications"
    "ICONDIR=$(out)/share/pixmaps"
    "METAINFODIR=$(out)/share/metainfo"
  ];

  meta = {
    description = "TeX and LaTeX editor";
    longDescription = ''
      This editor is a full fledged IDE for TeX and
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "http://www.xm1math.net/texmaker/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "texmaker";
  };
})
