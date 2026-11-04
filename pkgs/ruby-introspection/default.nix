{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "introspection";
  version = "0.0.4";
  source.sha256 = "1y2nbijkc0zlfmn9ss6588ilarq2kbn2i7w7pwwsli66dj84zgca";

  meta = {
    description = "Dynamic inspection of the hierarchy of method definitions on a Ruby object";
    homepage = "https://github.com/floehopper/introspection";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
