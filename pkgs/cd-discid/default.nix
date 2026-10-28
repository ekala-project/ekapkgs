{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cd-discid";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "taem";
    repo = "cd-discid";
    tag = finalAttrs.version;
    hash = "sha256-HHpqMRJr4PkmKgqGTyr8JSErcnQ2jwBqyCr4MvDoP68=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "INSTALL=install"
  ];

  meta = {
    description = "Utility to get CDDB disc IDs from audio CDs";
    homepage = "https://github.com/taem/cd-discid";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "cd-discid";
  };
})
