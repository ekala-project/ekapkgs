{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clipper2";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "AngusJohnson";
    repo = "Clipper2";
    tag = "Clipper2_${finalAttrs.version}";
    hash = "sha256-Pqmrj9SDooM+VU4ObQrtaU9+GN//FsD+Brp+OsN0cPM=";
  };

  sourceRoot = "${finalAttrs.src.name}/CPP";

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    CLIPPER2_EXAMPLES = false;
    CLIPPER2_TESTS = false;
    BUILD_SHARED_LIBS = true;
  };

  meta = {
    description = "Polygon Clipping and Offsetting - C++ Only";
    longDescription = ''
      The Clipper2 library performs intersection, union, difference and XOR boolean operations on both simple and
      complex polygons. It also performs polygon offsetting.
    '';
    homepage = "https://github.com/AngusJohnson/Clipper2";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
  };
})
