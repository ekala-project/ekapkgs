{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
  lxqt-build-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsysstat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libsysstat";
    tag = finalAttrs.version;
    hash = "sha256-CwQz0vaBhMe32xBoSgFkxSwx3tnIHutp9Vs32FvTNVU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  meta = {
    description = "Library used to query system info and statistics";
    homepage = "https://github.com/lxqt/libsysstat";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
