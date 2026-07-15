{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdiscid";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "libdiscid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lGq2iGt7c4h8HntEPeQcd7X+IykRLm0kvjrLswRWSSs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  meta = {
    description = "C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = "https://musicbrainz.org/doc/libdiscid";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
