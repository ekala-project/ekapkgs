{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alegreya";
  version = "2.008";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "huertatipografica";
    repo = "Alegreya";
    tag = "v${finalAttrs.version}";
    sha256 = "1m5xr95y6qxxv2ryvhfck39d6q5hxsr51f530fshg53x48l2mpwr";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Elegant and versatile font family for comfortable reading";
    homepage = "https://www.huertatipografica.com/en/fonts/alegreya-ht-pro";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
