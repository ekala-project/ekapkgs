{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  opencl-headers,
  ocl-icd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clblast";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "CNugteren";
    repo = "CLBlast";
    rev = finalAttrs.version;
    hash = "sha256-ikbu7yDE7NgxHhIJpt6LIEqUuon4Qha7FB3EeX5W01c=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  buildInputs = [
    opencl-headers
    ocl-icd
  ];

  cmakeFlags = [
    # https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    description = "Tuned OpenCL BLAS library";
    homepage = "https://github.com/CNugteren/CLBlast";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
