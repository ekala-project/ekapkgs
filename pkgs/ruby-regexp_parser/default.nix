{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "regexp_parser";
  version = "2.13.1";
  source.sha256 = "0jxl6c5cagjz5i5n9jplhdy2izad6wapmwgfhqggb22nqfvvdvas";

  meta = {
    description = "A library for tokenizing, lexing, and parsing Ruby regular expressions";
    homepage = "https://github.com/ammar/regexp_parser";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
