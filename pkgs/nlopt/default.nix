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

  cmakeEntries = {
    NLOPT_CXX = true;
    NLOPT_PYTHON = false;
    NLOPT_OCTAVE = false;
    NLOPT_JAVA = false;
    NLOPT_SWIG = false;
    NLOPT_FORTRAN = false;
    NLOPT_MATLAB = false;
    NLOPT_GUILE = false;
    NLOPT_TESTS = false;
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
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
