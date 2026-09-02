{
  lib,
  fetchurl,
  readline,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "units";
  version = "2.24";

  src = fetchurl {
    url = "mirror://gnu/units/units-${finalAttrs.version}.tar.gz";
    hash = "sha256-HlAsTt+s8gspKEcWxy5d21GklaI2XXsD55YElMSgyQI=";
  };

  outputs = [
    "out"
    "info"
    "man"
  ];

  buildInputs = [
    readline
  ];

  doCheck = true;

  meta = {
    homepage = "https://www.gnu.org/software/units/";
    description = "Unit conversion tool";
    license = lib.licenses.gpl3Plus;
    mainProgram = "units";
    platforms = lib.platforms.all;
  };
})
