{
  lib,
  stdenv,
  fetchurl,
  cmake,
  hdf5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "medfile";
  version = "6.0.1";

  src = fetchurl {
    url = "https://files.salome-platform.org/Salome/medfile/med-${finalAttrs.version}.tar.gz";
    hash = "sha256-+PHtxodLxI2PPk6L4c9zee0xhybYq8aAToXoIVVbH6g=";

    curlOptsList = [
      "--user-agent"
      "MozillaFirefox (really Nixpkgs, see https://github.com/NixOS/nixpkgs/pull/474599)"
    ];
  };

  outputs = [
    "out"
    "doc"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ hdf5 ];

  checkPhase = "make test";

  postInstall = "rm -r $out/bin/testc";

  meta = {
    description = "Library to read and write MED files";
    homepage = "https://salome-platform.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
})
