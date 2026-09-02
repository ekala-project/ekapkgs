{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gifsicle";
  version = "1.96";

  src = fetchurl {
    url = "https://www.lcdf.org/gifsicle/gifsicle-${finalAttrs.version}.tar.gz";
    hash = "sha256-/SPSeWgabf48FSZOM/NEBFs7pHPaTRn0nmelCZSwd/s=";
  };

  configureFlags = [ "--disable-gifview" ];

  doCheck = true;
  checkPhase = ''
    ./src/gifsicle --info logo.gif
  '';

  meta = {
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = "https://www.lcdf.org/gifsicle/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
