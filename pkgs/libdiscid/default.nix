{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdiscid";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "libdiscid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ynQuEzHblXnqvV6bKtjJNFuwUkd/ACVCy+jFfUAD+jo=";
  };

  # Fix broken .pc file paths when CMAKE_INSTALL_LIBDIR/INCLUDEDIR are absolute
  postPatch = ''
    sed -i CMakeLists.txt \
      -e '/SET(includedir/s|.*|SET(includedir ''${CMAKE_INSTALL_FULL_INCLUDEDIR})|' \
      -e '/SET(libdir/s|.*|SET(libdir ''${CMAKE_INSTALL_FULL_LIBDIR})|'
  '';

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
