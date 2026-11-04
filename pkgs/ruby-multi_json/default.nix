{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "multi_json";
  version = "1.17.0";
  source.sha256 = "06sabsvnw0x1aqdcswc6bqrqz6705548bfd8z22jxgxfjrn1yn3n";

  meta = {
    description = "General-purpose swappable JSON backend library";
    homepage = "https://github.com/intridea/multi_json";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
