{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crcpp";
  version = "1.2.3.0";

  src = fetchFromGitHub {
    owner = "d-bahr";
    repo = "CRCpp";
    rev = "release-${finalAttrs.version}";
    sha256 = "sha256-kzTNmVxN7iJ+fNS65g9UFvwtHUPntGa94bVqIr94aCE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  postPatch = ''
    substituteInPlace cmake/CRCpp.pc.in \
      --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' \
                      'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  doCheck = true;

  meta = {
    homepage = "https://github.com/d-bahr/CRCpp";
    changelog = "https://github.com/d-bahr/CRCpp/releases/tag/release-${finalAttrs.version}";
    description = "Easy to use and fast C++ CRC library";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
})
