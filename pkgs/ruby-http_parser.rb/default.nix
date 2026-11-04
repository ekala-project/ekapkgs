{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "http_parser.rb";
  version = "0.8.1";
  source.sha256 = "0yh924g697spcv4hfigyxgidhyy6a7b9007rnac57airbcadzs4s";

  meta = {
    description = "Ruby bindings to http-parser";
    homepage = "https://github.com/tmm1/http_parser.rb";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
