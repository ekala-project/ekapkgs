{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yvhpgiZpjTPeSY7Ma1bh4LwIokUUKB10v2WHlamL9D8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DBOX2D_BUILD_UNIT_TESTS=OFF"
    "-DBOX2D_BUILD_TESTBED=OFF"
  ];

  meta = {
    description = "2D physics engine";
    homepage = "https://box2d.org/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
