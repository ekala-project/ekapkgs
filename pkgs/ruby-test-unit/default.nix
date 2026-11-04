{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "test-unit";
  version = "3.7.8";
  source.sha256 = "0hsrsvl2fmvwvv28q8xrx32pzy4l8a78vmp5niwgcijd7yjir7b8";

  meta = {
    description = "Unit testing framework for Ruby based on xUnit principles";
    homepage = "https://test-unit.github.io/";
    license = lib.licenses.ruby;
    platforms = ruby.meta.platforms;
  };
}
