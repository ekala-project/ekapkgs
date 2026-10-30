{
  buildRubyGem,
  lib,
  ruby,
  rspec-support,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rspec-core";
  version = "3.13.6";
  source.sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";

  propagatedBuildInputs = [ rspec-support ];

  meta = {
    description = "RSpec runner and formatters";
    homepage = "https://github.com/rspec/rspec-core";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
