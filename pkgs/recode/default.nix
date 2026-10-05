{
  lib,
  stdenv,
  fetchurl,
  python3Packages,
  perl,
  flex,
  texinfo,
  libiconv,
  libintl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "recode";
  version = "3.7.16";

  src = fetchurl {
    url = "https://github.com/rrthomas/recode/releases/download/v${finalAttrs.version}/recode-${finalAttrs.version}.tar.gz";
    hash = "sha256-w9QH9U90uudjYDEgluLtRmIvAchuULCe9Fstk8j8/y0=";
  };

  nativeBuildInputs = [
    python3Packages.python
    perl
    flex
    texinfo
    libiconv
  ];

  buildInputs = [ libintl ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/rrthomas/recode";
    description = "Converts files between various character sets and usages";
    mainProgram = "recode";
    changelog = "https://github.com/rrthomas/recode/raw/v${finalAttrs.version}/NEWS";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
  };
})
