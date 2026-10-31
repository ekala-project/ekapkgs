{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "tilt";
  version = "2.9.0";
  source.sha256 = "19d3k8ym9bj9j98zmc0pbjnwqdg4mqabnh8hm7lrdfhb5383amys";

  meta = {
    description = "Generic interface to multiple Ruby template engines";
    homepage = "https://github.com/jeremyevans/tilt";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
