{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libidn";
  version = "1.43";

  src = fetchurl {
    url = "mirror://gnu/libidn/libidn-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-vcZiwS0EGyU50OY486bnQRMM2zOmRO80lpY6RDSC0WQ=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "info"
    "devdoc"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://www.gnu.org/software/libidn/";
    description = "Library for internationalized domain names";
    mainProgram = "idn";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
  };
})
