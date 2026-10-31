{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "crass";
  version = "1.0.6";
  source.sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";

  meta = {
    description = "CSS parser based on the CSS Syntax Level 3 spec";
    homepage = "https://github.com/rgrove/crass";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
