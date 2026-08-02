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
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xeus";
    tag = finalAttrs.version;
    hash = "sha256-siQzTu2IYHLbZrgLTbHPt8Ek8vLA/wXB0jx7oXC6d7k=";
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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
