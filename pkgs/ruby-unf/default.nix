{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "unf";
  version = "0.2.0";
  source.sha256 = "e6bcc2e101d80e3f9459753db747d5926aada1aaaf61e629e93359da9a5b04ab";

  meta = {
    description = "Unicode Normalization Form support library for CRuby";
    homepage = "https://github.com/knu/ruby-unf";
    license = lib.licenses.bsd2;
    platforms = ruby.meta.platforms;
  };
}
