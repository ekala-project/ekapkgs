{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation {
  pname = "aacgain";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dgilman";
    repo = "aacgain";
    rev = "9f9ae95a20197d1072994dbd89672bba2904bdb5";
    hash = "sha256-WqL9rKY4lQD7wQSZizoM3sHNzLIG0E9xZtjw8y7fgmE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    autoconf
    automake
    libtool
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=narrowing -DHAVE_GETOPT_H=1";

  meta = {
    description = "ReplayGain for AAC files";
    homepage = "https://github.com/dgilman/aacgain";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "aacgain";
  };
}
