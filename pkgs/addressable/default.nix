{
  buildRubyGem,
  lib,
  ruby,
  public_suffix,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "addressable";
  version = "2.8.7";
  source.sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";

  propagatedBuildInputs = [ public_suffix ];

  meta = {
    description = "URI implementation that correctly handles IRIs and URI templates";
    homepage = "https://github.com/sporkmonger/addressable";
    license = lib.licenses.asl20;
    platforms = ruby.meta.platforms;
  };
}
