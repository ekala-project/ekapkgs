{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "victor-mono";
  version = "1.5.6";

  src = fetchzip {
    url = "https://github.com/rubjo/victor-mono/raw/v${version}/public/VictorMonoAll.zip";
    stripRoot = false;
    hash = "sha256-PnCCU7PO+XcxUk445sU5xVl8XqdSPJighjtDTqI6qiw=";
  };

  nativeBuildInputs = [ installFonts ];

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
