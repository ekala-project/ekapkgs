{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  curl,
  libxml2,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "raptor";
  version = "2.0.16";

  src = fetchurl {
    url = "https://librdf.org/dist/source/raptor2-${finalAttrs.version}.tar.gz";
    hash = "sha256-CJ23jXrJgjVL2/OdlzuvCVgeaQSsTJKpjFyq2z3kRoA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    curl
    libxml2
    libxslt
  ];

  meta = {
    description = "RDF syntax parsing and serializing library";
    homepage = "https://librdf.org/raptor/";
    license = with lib.licenses; [
      asl20
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.unix;
  };
})
