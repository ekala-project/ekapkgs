{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "unicode-display_width";
  version = "3.2.0";
  source.sha256 = "0hiwhnqpq271xqari6mg996fgjps42sffm9cpk6ljn8sd2srdp8c";

  meta = {
    description = "Determines the monospace display width of a string in Ruby";
    homepage = "https://github.com/janlelis/unicode-display_width";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
