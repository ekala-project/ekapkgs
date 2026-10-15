{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  libsecret,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtkeychain";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = finalAttrs.version;
    sha256 = "sha256-6Aw+hy3WCTr3iEiZns7aH82nkVSG/KMqEA2LE0XZ7Zo=";
  };

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_WITH_QT5 = false;
    QT_TRANSLATIONS_DIR = "share/qt/translations";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libsecret
    qt6.qtbase
    qt6.qttools
  ];

  meta = {
    description = "Platform-independent Qt API for storing passwords securely";
    homepage = "https://github.com/frankosterfeld/qtkeychain";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
