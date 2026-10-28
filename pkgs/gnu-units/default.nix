{
  lib,
  stdenv,
  fetchurl,
  readline,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnu-units";
  version = "2.23";

  src = fetchurl {
    url = "mirror://gnu/units/units-${finalAttrs.version}.tar.gz";
    hash = "sha256-2Ve0USRZJcnmFMRRM5dEljDq+SvWK4SVugm741Ghc3A=";
  };

  buildInputs = [
    python3
    readline
  ];

  meta = {
    description = "GNU unit conversion tool";
    homepage = "https://www.gnu.org/software/units/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "units";
  };
})
