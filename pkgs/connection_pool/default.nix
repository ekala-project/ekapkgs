{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "connection_pool";
  version = "3.0.2";
  source.sha256 = "02ifws3c4x7b54fv17sm4cca18d2pfw1saxpdji2lbd1f6xgbzrk";

  meta = {
    description = "Generic connection pool for Ruby";
    homepage = "https://github.com/mperham/connection_pool";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
