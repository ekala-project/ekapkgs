{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "KDSingleApplication";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "KDSingleApplication";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LmiQL8hQR5U4S/L5FS9Pb2WpOoZJyiAaWGoMkGl5aUM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ qt6.qtbase ];

  cmakeEntries = {
    KDSingleApplication_QT6 = "true";
  };

  # The multiline project() in CMakeLists.txt causes parseShareDocName to fail
  # under set -e -o pipefail, so we set this explicitly.
  shareDocName = "KDSingleApplication";

  dontWrapQtApps = true;

  meta = {
    description = "KDAB's helper class for single-instance policy applications";
    homepage = "https://www.kdab.com/";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    changelog = "https://github.com/KDAB/KDSingleApplication/releases/tag/v${finalAttrs.version}";
  };
})
