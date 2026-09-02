{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nlopt";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "stevengj";
    repo = "nlopt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ooZv75xkg07w+8ZlP1+1hqVwhOuDBSBNfhFscsLLu1I=";
  };

  postPatch = ''
    substituteInPlace nlopt.pc.in \
      --replace-fail 'libdir=''${exec_prefix}/@NLOPT_INSTALL_LIBDIR@' 'libdir=@NLOPT_INSTALL_LIBDIR@'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "NLOPT_CXX" true)
    (lib.cmakeBool "NLOPT_PYTHON" false)
    (lib.cmakeBool "NLOPT_OCTAVE" false)
    (lib.cmakeBool "NLOPT_JAVA" false)
    (lib.cmakeBool "NLOPT_SWIG" false)
    (lib.cmakeBool "NLOPT_FORTRAN" false)
    (lib.cmakeBool "NLOPT_MATLAB" false)
    (lib.cmakeBool "NLOPT_GUILE" false)
    (lib.cmakeBool "NLOPT_TESTS" false)
  ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/nlopt/NLoptLibraryDepends.cmake --replace-fail \
      'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/' 'INTERFACE_INCLUDE_DIRECTORIES "'
  '';

  meta = {
    homepage = "https://nlopt.readthedocs.io/en/latest/";
    description = "Free open-source library for nonlinear optimization";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
})
