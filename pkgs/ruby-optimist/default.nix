{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "optimist";
  version = "3.2.1";
  source.sha256 = "0kp3f8g7g7cbw5vfkmpdv71pphhpcxk3lpc892mj9apkd7ys1y4c";

  meta = {
    description = "Commandline option parser for Ruby that gets out of your way";
    homepage = "http://manageiq.github.io/optimist/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
