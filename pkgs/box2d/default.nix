{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IqQy9A8fWLG9H8ZPmOXeFZDaaks84miRuzXaFlNwm0g=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DBOX2D_UNIT_TESTS=OFF"
    "-DBOX2D_SAMPLES=OFF"
    "-DBOX2D_BENCHMARKS=OFF"
  ];

  meta = {
    description = "2D physics engine";
    homepage = "https://box2d.org/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
