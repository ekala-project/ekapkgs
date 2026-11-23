{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cd-discid";
  version = "1.4-1";

  src = fetchFromGitHub {
    owner = "taem";
    repo = "cd-discid";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-dc1sfzpHHjXwzFNUkW8io1gpCl3eSIQiWekn6bu1wwU=";
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
