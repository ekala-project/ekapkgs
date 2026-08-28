{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  nlohmann_json,
  libuuid,
  xtl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeus";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xeus";
    tag = finalAttrs.version;
    hash = "sha256-m3j9BOoEqcyvmqsc3WEo+I+R5+/TbhsHi7hrqmn9MYY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    doctest
  ];

  buildInputs = [
    nlohmann_json
    libuuid
  ];

  cmakeFlags = [
    "-DXEUS_BUILD_TESTS=ON"
  ];

  doCheck = true;
  preCheck = "export LD_LIBRARY_PATH=$PWD";

  meta = {
    homepage = "https://xeus.readthedocs.io";
    description = "C++ implementation of the Jupyter Kernel protocol";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
