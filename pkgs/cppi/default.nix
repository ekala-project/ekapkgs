{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppi";
  version = "1.18";

  src = fetchurl {
    url = "mirror://gnu/cppi/cppi-${finalAttrs.version}.tar.xz";
    hash = "sha256-EqUFuYhj9sXPH3SfkIC+O0Kz6sWjW1ljDme+pyQTZMo=";
  };

  meta = {
    description = "C preprocessor directive indenter";
    homepage = "https://savannah.gnu.org/projects/cppi/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "cppi";
  };
})
