{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.4";
  pname = "nanomsg";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = finalAttrs.version;
    sha256 = "sha256-Tz3JyDUBSuzWdRjnBw8X9aqiMfziMfkY75Tuj3be28g=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Socket library that provides several common communication patterns";
    homepage = "https://nanomsg.org/";
    license = lib.licenses.mit;
    mainProgram = "nanocat";
    platforms = lib.platforms.unix;
  };
})
