{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  expat,
  openssl,
  zlib,
  lmdb,
  curl,
  sqlite,
  wxwidgets_3_2,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tqsl";
  version = "2.8.6";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/tqsl-${finalAttrs.version}.tar.gz";
    hash = "sha256-GC5fKsNaPbi0CbRdllBea9JlrkZo7QZHVCCcS4573zc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    expat
    openssl
    zlib
    lmdb
    curl
    sqlite
    wxwidgets_3_2
  ];

  meta = {
    description = "Software for using the ARRL Logbook of the World";
    mainProgram = "tqsl";
    homepage = "https://www.arrl.org/tqsl-download";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
