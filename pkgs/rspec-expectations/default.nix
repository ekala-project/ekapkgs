{
  buildRubyGem,
  lib,
  ruby,
  diff-lcs,
  rspec-support,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rspec-expectations";
  version = "3.13.5";
  source.sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";

  propagatedBuildInputs = [
    diff-lcs
    rspec-support
  ];

  meta = {
    description = "RSpec expectations and matchers";
    homepage = "https://github.com/rspec/rspec-expectations";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
