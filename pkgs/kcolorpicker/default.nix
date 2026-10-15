{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcolorpicker";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ksnip";
    repo = "kColorPicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FG/A4pDNuhGPOeJNZlsnX3paEy4ibJVWKxn8rVUGpN8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt6.qtbase ];

  cmakeEntries = {
    BUILD_WITH_QT6 = true;
    BUILD_SHARED_LIBS = true;
  };

  dontWrapQtApps = true;

  meta = {
    description = "Qt based Color Picker with popup menu";
    homepage = "https://github.com/ksnip/kColorPicker";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
