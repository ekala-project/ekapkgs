{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  removeReferencesTo,
  alsa-lib,
}:

stdenv.mkDerivation rec {
  pname = "openal-soft";
  version = "1.25.2";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "openal-soft";
    rev = version;
    sha256 = "sha256-+yG5qB5sg86RgmFIaPNNsLZZ1IM0AvNdzWPVN/PQLGw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    removeReferencesTo
  ];

  buildInputs = [
    alsa-lib
  ];

  cmakeFlags = [
    "-DALSOFT_DLOPEN=OFF"
    "-DALSOFT_SEARCH_INSTALL_DATADIR=1"
    "-DALSOFT_BACKEND_OSS=OFF"
  ];

  meta = {
    description = "OpenAL alternative";
    homepage = "https://openal-soft.org/";
    license = lib.licenses.lgpl2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
