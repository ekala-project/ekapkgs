{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  kcolorpicker,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kimageannotator";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kImageAnnotator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SKNNsBXmaS0ZnbMP7cKSfr+MM+ICdvYQ0k2h5s9SDcE=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  propagatedBuildInputs = [ kcolorpicker ];

  cmakeEntries = {
    BUILD_WITH_QT6 = true;
    BUILD_SHARED_LIBS = true;
  };

  dontWrapQtApps = true;

  meta = {
    description = "Tool for annotating images";
    homepage = "https://github.com/ksnip/kImageAnnotator";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
