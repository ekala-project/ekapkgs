{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "kramdown-parser-gfm";
  version = "1.1.0";
  source.sha256 = "0a8pb3v951f4x7h968rqfsa19c8arz21zw1vaj42jza22rap8fgv";

  meta = {
    description = "kramdown parser for the GFM dialect of Markdown";
    homepage = "https://github.com/kramdown/parser-gfm";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
