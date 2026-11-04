{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rr";
  version = "3.1.2";
  source.sha256 = "cc4a5cc91f012327d317dc661154419f9d36d8f9c05031ac46accd89ceb0ff1b";

  meta = {
    description = "Test double framework for Ruby with a terse syntax";
    homepage = "https://github.com/rr/rr";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
