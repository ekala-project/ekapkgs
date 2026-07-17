{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gflags";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "gflags";
    repo = "gflags";
    rev = "v${finalAttrs.version}";
    sha256 = "147i3md3nxkjlrccqg4mq1kyzc7yrhvqv5902iibc7znkvzdvlp0";
  };

  patches = [
    (fetchpatch {
      name = "gflags-fix-cmake-4.patch";
      url = "https://github.com/gflags/gflags/commit/70c01a642f08734b7bddc9687884844ca117e080.patch";
      hash = "sha256-TYdroBbF27Wvvm/rOahBEvhezuKCcxbtgh/ZhpA5ESo=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  preConfigure = "rm BUILD";

  cmakeFlags = [
    "-DGFLAGS_BUILD_SHARED_LIBS=ON"
    "-DGFLAGS_BUILD_STATIC_LIBS=ON"
  ];

  doCheck = false;

  meta = {
    description = "C++ library that implements commandline flags processing";
    homepage = "https://gflags.github.io/gflags/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
