{
  buildRubyGem,
  lib,
  ruby,
  concurrent-ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "tzinfo";
  version = "2.0.6";
  source.sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";

  propagatedBuildInputs = [ concurrent-ruby ];

  meta = {
    description = "Ruby timezone library";
    homepage = "https://tzinfo.github.io";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
