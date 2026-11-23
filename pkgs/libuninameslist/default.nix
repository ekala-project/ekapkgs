{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libuninameslist";
  version = "20260918";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "libuninameslist";
    tag = finalAttrs.version;
    hash = "sha256-QTrC+j12rf3S7boKrsKUc5qRavXbOoP8K93/+K8Wvag=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    homepage = "https://github.com/fontforge/libuninameslist/";
    description = "Library of Unicode names and annotation data";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
