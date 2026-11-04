{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "hashdiff";
  version = "1.2.1";
  source.sha256 = "1lbw8lqzjv17vnwb9vy5ki4jiyihybcc5h2rmcrqiz1xa6y9s1ww";

  meta = {
    description = "Diff library for computing the smallest difference between two hashes";
    homepage = "https://github.com/liufengyun/hashdiff";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
