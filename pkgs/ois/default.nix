{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ois";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "wgois";
    repo = "OIS";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-SQ5wUNwU0Wel//72gcmIkEiN0CslzyI7HHmGhwm75FY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    description = "Object-oriented C++ input system";
    homepage = "https://github.com/wgois/OIS";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.zlib;
  };
})
