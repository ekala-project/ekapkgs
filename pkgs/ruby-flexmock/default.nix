{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "flexmock";
  version = "3.0.2";
  source.sha256 = "0y180zgv5x41ssaqs5zjq75jbl9p710n7zkwjv1nm3sgvdrlxpav";

  meta = {
    description = "Flexible mock object library for Ruby";
    homepage = "https://github.com/doudou/flexmock";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
