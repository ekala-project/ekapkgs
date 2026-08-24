{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reproc";
  version = "14.2.7";

  src = fetchFromGitHub {
    owner = "DaanDeMeyer";
    repo = "reproc";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qaUsbQDcgNSHZWMu95jxLeZoXWNo/Ka0dlzVnbAIXMY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DBUILD_SHARED_LIBS=ON"
    "-DREPROC++=ON"
    "-DREPROC_TEST=ON"
  ];

  # https://github.com/DaanDeMeyer/reproc/issues/81
  postPatch = ''
    substituteInPlace reproc++/reproc++.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace reproc/reproc.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = {
    homepage = "https://github.com/DaanDeMeyer/reproc";
    description = "Cross-platform (C99/C++11) process library";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
