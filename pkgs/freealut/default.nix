{
  lib,
  stdenv,
  fetchurl,
  openal,
}:

stdenv.mkDerivation rec {
  pname = "freealut";
  version = "1.1.0";

  src = fetchurl {
    url = "http://www.openal.org/openal_webstf/downloads/freealut-${version}.tar.gz";
    sha256 = "0kzlil6112x2429nw6mycmif8y6bxr2cwjcvp18vh6s7g63ymlb0";
  };

  buildInputs = [
    openal
  ];

  meta = {
    homepage = "https://openal.org/";
    description = "Free implementation of OpenAL's ALUT standard";
    mainProgram = "freealut-config";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
