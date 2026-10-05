{
  lib,
  stdenv,
  fetchurl,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wdiff";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://gnu/wdiff/wdiff-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-KaRFfrDtNckC5nMtcfJeHWx/5/oO2g+2w3HtZ3m0n9Y=";
  };

  nativeBuildInputs = [ texinfo ];

  buildInputs = [ texinfo ];

  strictDeps = true;

  meta = {
    homepage = "https://www.gnu.org/software/wdiff/";
    description = "Comparing files on a word by word basis";
    mainProgram = "wdiff";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
