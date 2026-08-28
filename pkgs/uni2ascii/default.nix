{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uni2ascii";
  version = "4.20";

  src = fetchurl {
    url = "https://billposer.org/Software/Downloads/uni2ascii-${finalAttrs.version}.tar.gz";
    hash = "sha256-7tjYOpwdLb0NfKTFJRmYg9cxfWiLQhtXjQmKJ7b/cFY=";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/Homebrew/formula-patches/raw/bb92449ad6b3878b4d6f472237152df28080df86/uni2ascii/uni2ascii-4.20.patch";
      hash = "sha256-JQpSntoTbQ7fnmO5Km/pX071360/lOb9jYdxOK2oV/g=";
    })
  ];

  meta = {
    description = "Converts between UTF-8 and many 7-bit ASCII equivalents and back";
    homepage = "http://billposer.org/Software/uni2ascii.html";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
})
