{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "test-unit-rr";
  version = "1.0.5";
  source.sha256 = "0l42wxvqqd4g1968syy1wmr4j9z3cad8v5vv22lr7my4wjgz0sil";

  meta = {
    description = "Integration of RR mocking library with test-unit";
    homepage = "https://github.com/test-unit/test-unit-rr";
    license = lib.licenses.lgpl2Plus;
    platforms = ruby.meta.platforms;
  };
}
