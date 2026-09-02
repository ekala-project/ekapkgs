{
  lib,
  stdenv,
  libxml2,
  curl,
  libxslt,
  pkg-config,
  cmake,
  fetchFromGitHub,
  perl,
  bison,
  flex,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "raptor2";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = "dajobe";
    repo = "raptor";
    rev = "${pname}_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-Eic63pV2p154YkSmkqWr86fGTr+XmVGy5l5/6q14LQM=";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  patches = [
    (fetchpatch {
      name = "libxml2-2.11.patch";
      url = "https://github.com/dajobe/raptor/commit/4dbc4c1da2a033c497d84a1291c46f416a9cac51.patch";
      hash = "sha256-fHfvncGymzMtxjwtakCNSr/Lem12UPIHAAcAac648w4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
    perl
    bison
    flex
  ];

  buildInputs = [
    curl
    libxml2
    libxslt
  ];

  meta = {
    description = "RDF Parser Toolkit";
    mainProgram = "rapper";
    homepage = "https://librdf.org/raptor";
    license = with lib.licenses; [
      lgpl21
      asl20
    ];
    platforms = lib.platforms.unix;
  };
}
