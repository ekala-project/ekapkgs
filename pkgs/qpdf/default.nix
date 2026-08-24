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
  version = "12.4.0";

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ubxoVLU6gELRRsFJMddM07i+JH53P82tN5n3nH2gQn4=";
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
