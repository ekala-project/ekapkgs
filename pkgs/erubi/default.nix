{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "erubi";
  version = "1.13.1";
  source.sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";

  meta = {
    description = "ERB template engine for Ruby, a simplified fork of Erubis";
    homepage = "https://github.com/jeremyevans/erubi";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
