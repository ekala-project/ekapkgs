{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccrypt";
  version = "1.11";

  src = fetchurl {
    url = "mirror://sourceforge/ccrypt/ccrypt-${finalAttrs.version}.tar.gz";
    sha256 = "0kx4a5mhmp73ljknl2lcccmw9z3f5y8lqw0ghaymzvln1984g75i";
  };

  nativeBuildInputs = [ perl ];

  hardeningDisable = [ "format" ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Utility for encrypting and decrypting files and streams with AES-256";
    homepage = "https://ccrypt.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
