{
  buildRubyGem,
  lib,
  ruby,
  rspec-core,
  rspec-expectations,
  rspec-mocks,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rspec";
  version = "3.13.2";
  source.sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";

  propagatedBuildInputs = [
    rspec-core
    rspec-expectations
    rspec-mocks
  ];

  meta = {
    description = "Behaviour Driven Development framework for Ruby";
    homepage = "https://rspec.info";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
