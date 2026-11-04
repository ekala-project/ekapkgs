{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rack-test";
  version = "2.3.0";
  source.sha256 = "1s212a39z3v1ksgnhvwddsiq2n7dr4cqvzdnq4pmfb00rivx265i";

  meta = {
    description = "Simple testing API built on Rack";
    homepage = "https://github.com/rack/rack-test";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
