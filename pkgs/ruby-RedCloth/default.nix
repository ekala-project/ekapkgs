{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "RedCloth";
  version = "4.3.4";
  source.sha256 = "15r2h7rfp4bi9i0bfmvgnmvmw0kl3byyac53rcakk4qsv7yv4caj";

  meta = {
    description = "Textile parser for Ruby";
    homepage = "http://redcloth.org";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
