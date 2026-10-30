{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  perl,
  bison,
  flex,
  curl,
  libxml2,
  libxslt,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "raptor2";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = "dajobe";
    repo = "raptor";
    tag = "raptor2_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-Eic63pV2p154YkSmkqWr86fGTr+XmVGy5l5/6q14LQM=";
  };

  patches = [
    # pull upstream fix for libxml2-2.11 API compatibility, part of unreleased 2.0.17
    #   https://github.com/dajobe/raptor/pull/58
    (fetchpatch {
      name = "libxml2-2.11.patch";
      url = "https://github.com/dajobe/raptor/commit/4dbc4c1da2a033c497d84a1291c46f416a9cac51.patch";
      hash = "sha256-fHfvncGymzMtxjwtakCNSr/Lem12UPIHAAcAac648w4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
    bison
    flex
  ];

  buildInputs = [
    curl
    libxml2
    libxslt
  ];

  cmakeEntries = {
    BUILD_SHARED_LIBS = !static;
  };

  # Fix the build with CMake 4.
  #
  # See: <https://github.com/dajobe/raptor/issues/75>
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7)' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.10)'
  '';

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
})
