{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "haml";
  version = "6.3.0";
  source.sha256 = "15yxph91zswbnfy7szpdcfbdfqqn595ff290hm4f6fcnhryvhvlf";

  meta = {
    description = "HTML Abstraction Markup Language - A Markup Haiku";
    homepage = "https://haml.info/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
