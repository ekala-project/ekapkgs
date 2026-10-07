{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  openssl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.12.0";
  pname = "libre";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "re";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-lZ/C2+ymPMYq0K0PiuOr/aEpHAWMOZZFBE6wNO/hGcM=";
  };

  buildInputs = [
    openssl
    zlib
  ];

  nativeBuildInputs = [
    cmake.configurePhaseHook
    cmake
  ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];
  meta = {
    description = "Library for real-time communications with async IO support and a complete SIP stack";
    homepage = "https://github.com/baresip/re";
    license = lib.licenses.bsd3;
  };
})
