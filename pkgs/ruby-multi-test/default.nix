{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "multi_test";
  version = "2.0.0";
  source.sha256 = "1rwll1y88q5c08zj3rq61wc4xkylzg364p7fn2z5xxmnldrbzqaz";

  meta = {
    description = "Wafer thin gem to help control rogue test/unit/autorun requires";
    homepage = "https://cucumber.io/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
