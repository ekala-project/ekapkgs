{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "power_assert";
  version = "3.1.0";
  source.sha256 = "0lc2a6kxr2lj7h6p0s8f6bqh3kkf9lczkygk720n4h1ibpnrizpy";

  meta = {
    description = "Power Assert for Ruby";
    homepage = "https://github.com/ruby/power_assert";
    license = lib.licenses.bsd2;
    platforms = ruby.meta.platforms;
  };
}
