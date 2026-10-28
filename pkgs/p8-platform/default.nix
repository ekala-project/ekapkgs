{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "p8-platform";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Pulse-Eight";
    repo = "platform";
    tag = "p8-platform-${finalAttrs.version}";
    hash = "sha256-wzKEqGgsqaNyRJoL3NxMAUycbIzF915xZQRZcDlnAoQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Platform support library used by libCEC";
    homepage = "https://github.com/Pulse-Eight/platform";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
