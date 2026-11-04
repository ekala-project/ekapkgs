{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rb-fsevent";
  version = "0.11.2";
  source.sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";

  meta = {
    description = "FSEvents API with Signals catching (without RubyCocoa)";
    homepage = "http://rubygems.org/gems/rb-fsevent";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
