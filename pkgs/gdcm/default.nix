{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enableVTK ? true,
  vtk,
  expat,
  libuuid,
  openjpeg,
  zlib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdcm";
  version = "3.2.10";

  src = fetchFromGitHub {
    owner = "malaterre";
    repo = "GDCM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cRMou+b+kA++ZFEKK1aX6ihfs9HH6iHU0NPbaDzrZoo=";
  };

  cmakeFlags = [
    "-DGDCM_BUILD_APPLICATIONS=ON"
    "-DGDCM_BUILD_SHARED_LIBS=ON"
    "-DGDCM_BUILD_TESTING=ON"
    "-DGDCM_USE_SYSTEM_EXPAT=ON"
    "-DGDCM_USE_SYSTEM_ZLIB=ON"
    "-DGDCM_USE_SYSTEM_UUID=ON"
    "-DGDCM_USE_SYSTEM_OPENJPEG=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals enableVTK [
    "-DGDCM_USE_VTK=ON"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    expat
    libuuid
    openjpeg
    zlib
  ]
  ++ lib.optionals enableVTK [
    vtk
  ];

  doCheck = true;

  meta = {
    description = "Grassroots cross-platform DICOM implementation";
    homepage = "https://gdcm.sourceforge.net";
    license = with lib.licenses; [
      bsd3
      asl20
    ];
    platforms = lib.platforms.all;
  };
})
