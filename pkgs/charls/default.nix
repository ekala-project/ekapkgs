{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "charls";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "team-charls";
    repo = "charls";
    tag = finalAttrs.version;
    hash = "sha256-0NfTQfGw89SksrLRX81moj6uFrh1I67JMeT16Wcus1c=";
  };

  postPatch = ''
    substituteInPlace src/charls-template.pc  \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@  \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/team-charls/charls";
    description = "JPEG-LS library implementation in C++";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
