{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "metaclass";
  version = "0.0.4";
  source.sha256 = "0hp99y2b1nh0nr8pc398n3f8lakgci6pkrg4bf2b2211j1f6hsc5";

  meta = {
    description = "Adds a metaclass method to all Ruby objects";
    homepage = "https://github.com/floehopper/metaclass";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
