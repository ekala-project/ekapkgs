{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rainbow";
  version = "3.1.1";
  source.sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";

  meta = {
    description = "Colorize printed text on ANSI terminals";
    homepage = "https://github.com/sickill/rainbow";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
