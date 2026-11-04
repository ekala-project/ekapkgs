{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "loofah";
  version = "2.25.2";
  source.sha256 = "062r891hxis58j5q735kk9sj5srxx0rv813f8m95bilsjm3gf1r0";

  meta = {
    description = "HTML/XML manipulation and sanitization library built on Nokogiri";
    homepage = "https://github.com/flavorjones/loofah";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
