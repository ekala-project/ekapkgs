{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "yard";
  version = "0.9.37";
  source.sha256 = "14k9lb9a60r9z2zcqg08by9iljrrgjxdkbd91gw17rkqkqwi1sd6";

  meta = {
    description = "Documentation generation tool for Ruby";
    homepage = "https://yardoc.org/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
