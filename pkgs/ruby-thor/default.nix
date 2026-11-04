{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "thor";
  version = "1.4.0";
  source.sha256 = "0gcarlmpfbmqnjvwfz44gdjhcmm634di7plcx2zdgwdhrhifhqw7";

  meta = {
    description = "Toolkit for building powerful command-line interfaces";
    homepage = "http://whatisthor.com/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
