{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "globalid";
  version = "1.4.0";
  source.sha256 = "09zl0rkskfq0cwfrk9ypjvflvzanfg3xbhh1slaa1myry7xi4zq3";

  meta = {
    description = "URIs for your models makes it easy to pass references around";
    homepage = "https://github.com/rails/globalid";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
