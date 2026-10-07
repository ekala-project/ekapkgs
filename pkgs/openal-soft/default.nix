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

  cmakeEntries = {
    ALSOFT_DLOPEN = false;
    ALSOFT_SEARCH_INSTALL_DATADIR = true;
    ALSOFT_BACKEND_OSS = false;
  };

  meta = {
    description = "OpenAL alternative";
    homepage = "https://openal-soft.org/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
