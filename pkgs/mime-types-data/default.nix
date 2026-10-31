{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mime-types-data";
  version = "3.2026.1027";
  source.sha256 = "0gyqylh01h5kidl5am1kafaqqkhnzjjzfxpbij51qk4p8jg74s25";

  meta = {
    description = "Registry for MIME media type definitions";
    homepage = "https://github.com/mime-types/mime-types-data/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
