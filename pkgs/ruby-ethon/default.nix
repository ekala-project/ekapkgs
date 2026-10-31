{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "ethon";
  version = "0.16.0";
  source.sha256 = "17ix0mijpsy3y0c6ywrk5ibarmvqzjsirjyprpsy3hwax8fdm85v";

  meta = {
    description = "Very lightweight libcurl wrapper";
    homepage = "https://github.com/typhoeus/ethon";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
