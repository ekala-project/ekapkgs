{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vid.stab";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "georgmartius";
    repo = "vid.stab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8YyIBYp3/tThQBrnZsiusKyhP2kO0qAsxTwy9mVQiRk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Video stabilization library";
    homepage = "http://public.hronopik.de/vid.stab/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
