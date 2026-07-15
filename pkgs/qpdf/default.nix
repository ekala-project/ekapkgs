{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libjpeg,
  perl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qpdf";
  version = "12.3.2";

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qHc9v3VYrxbOhpsPbaaO7foumI2AdeFN9Z9Zbs4XtKg=";
  };

  outputs = [
    "bin"
    "doc"
    "lib"
    "man"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    perl
  ];

  buildInputs = [
    zlib
    libjpeg
  ];

  preConfigure = ''
    patchShebangs qtest/bin/qtest-driver
    patchShebangs run-qtest
    substituteInPlace CMakeLists.txt --replace "run-qtest" "run-qtest --top $src --code $src --bin $out"
  '';

  meta = {
    homepage = "https://qpdf.sourceforge.io/";
    description = "C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "qpdf";
    platforms = lib.platforms.all;
  };
})
