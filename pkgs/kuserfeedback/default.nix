{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kuserfeedback";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kuserfeedback-${finalAttrs.version}.tar.xz";
    hash = "sha256-yKRjyOVw9tUyy+FQcyIgV1xjhd+XyROZtshEUGkXcco=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
    qt6.qtsvg
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  # Disable server-side stuff we don't care about
  cmakeEntries = {
    BUILD_TESTING = false;
    ENABLE_CONSOLE = false;
    ENABLE_CLI = false;
  };

  dontWrapQtApps = true;

  meta = {
    description = "Framework for collecting user feedback for applications";
    homepage = "https://invent.kde.org/frameworks/kuserfeedback";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
