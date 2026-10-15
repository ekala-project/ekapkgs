{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "rubik";
  version = "2.200";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "rubik";
    rev = "054aa9d546cd6308f8ff7139b332490e0967aebe";
    hash = "sha256-AkWMLbDIect48KLEYIIx/WNQ57P1Ivp5VrJP8mdj1oE=";
  };

  nativeBuildInputs = [ installFonts ];

  preInstall = "rm -r old/";

  meta = {
    homepage = "https://fonts.google.com/specimen/Rubik";
    description = "Rubik Font - is a 5 weight Roman + Italic family";
    platforms = lib.platforms.all;
    license = lib.licenses.ofl;
  };
}
