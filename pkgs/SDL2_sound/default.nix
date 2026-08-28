{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  sdl3,
  flac,
  libmikmod,
  libvorbis,
}:

stdenv.mkDerivation rec {
  pname = "SDL2_sound";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "SDL_sound";
    rev = "v${version}";
    hash = "sha256-Ael8OTLqmPNsX+Q+NwbXgVB9xZ0Wzv1p+IpIDWw1q+s=";
  };
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [ "-DSDLSOUND_DECODER_MIDI=0" ];

  buildInputs = [
    sdl3
    flac
    libmikmod
    libvorbis
  ];

  meta = {
    description = "SDL2 sound library";
    mainProgram = "playsound";
    platforms = lib.platforms.unix;
    license = lib.licenses.zlib;
    homepage = "https://www.icculus.org/SDL_sound/";
  };
}
