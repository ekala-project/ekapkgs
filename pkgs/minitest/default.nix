{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "minitest";
  version = "6.0.6";
  source.sha256 = "1wfnqyfayx9n9j7x871v2ars4hjhfisi1dl24fa64ylq3mns6ghm";

  meta = {
    description = "Complete testing suite supporting TDD, BDD, and benchmarking";
    homepage = "https://minite.st/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
