{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  libjack2,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.0.0";
  pname = "libsoundio";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = finalAttrs.version;
    sha256 = "12l4rvaypv87vigdrmjz48d4d6sq4gfxf5asvnc4adyabxb73i4x";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    libjack2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    alsa-lib
  ];

  meta = {
    description = "Cross platform audio input and output";
    homepage = "http://libsound.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
