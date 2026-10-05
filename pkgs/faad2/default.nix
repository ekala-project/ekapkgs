{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faad2";
  version = "2.11.4";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = finalAttrs.version;
    hash = "sha256-luBimrRvTMb1yo9ZXka2n2YJqmDtymR7ImbEcXqs7dE=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Open source MPEG-4 and MPEG-2 AAC decoder";
    homepage = "https://sourceforge.net/projects/faac/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "faad";
    platforms = lib.platforms.all;
  };
})
