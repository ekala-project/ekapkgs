{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glibcLocales,
  pkg-config,
  curl,
  glib,
  id3lib,
  libxml2,
  taglib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "castget";
  version = "2.0.1-unstable-2026-02-04";

  src = fetchFromGitHub {
    owner = "mlj";
    repo = "castget";
    rev = "218734296e2efc53071e0dbd3c4d59930b571aae";
    hash = "sha256-GEfsGOTBkorPWLGP3eNbuiGFwDUgb4Gu6ykyS3/RNOg=";
  };

  preBuild = ''
    export LC_ALL="en_US.UTF-8";
  '';

  buildInputs = [
    curl
    glib
    id3lib
    libxml2
    taglib
  ];
  nativeBuildInputs = [
    autoreconfHook
    glibcLocales
    pkg-config
  ];

  meta = {
    description = "Simple, command-line based RSS enclosure downloader";
    homepage = "https://castget.johndal.com";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "castget";
  };
})
