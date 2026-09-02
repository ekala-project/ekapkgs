{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "metis";
  version = "5.1.0";

  src = fetchurl {
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-${version}.tar.gz";
    sha256 = "1cjxgh41r8k6j029yxs8msp3z6lcnpm16g5pvckk35kc7zhfpykn";
  };

  cmakeFlags = [
    "-DGKLIB_PATH=../GKlib"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  nativeBuildInputs = [
    unzip
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Serial graph partitioning and fill-reducing matrix ordering";
    homepage = "http://glaros.dtc.umn.edu/gkhome/metis/metis/overview";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
