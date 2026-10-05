{
  lib,
  fetchurl,
  readline,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "units";
  version = "2.27";

  src = fetchurl {
    url = "mirror://gnu/units/units-${finalAttrs.version}.tar.gz";
    hash = "sha256-4bvbCWcufAju6YZ0nnoWKeuEpr30H1oqedaARESrvhA=";
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
