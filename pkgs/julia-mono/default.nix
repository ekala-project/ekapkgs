{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "JuliaMono-ttf";
  version = "0.63.2";

  src = fetchzip {
    url = "https://github.com/cormullion/juliamono/releases/download/v${version}/JuliaMono-ttf.tar.gz";
    stripRoot = false;
    hash = "sha256-trXylRLUUXW7x1bEKGQ/KtjlSlpHe0k6+9oIdeNuDQk=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Monospaced font for scientific and technical computing";
    homepage = "https://juliamono.netlify.app/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
