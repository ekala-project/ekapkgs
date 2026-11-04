{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rspec-its";
  version = "2.0.0";
  source.sha256 = "a88e8bc38149f2835e93533591ec4f5c829aacbfd41269a2e6f9f5b82f5260df";

  meta = {
    description = "RSpec extension that provides the its method";
    homepage = "https://github.com/rspec/rspec-its";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
