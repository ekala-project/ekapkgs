{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mustache";
  version = "1.1.1";
  source.sha256 = "1l0p4wx15mi3wnamfv92ipkia4nsx8qi132c6g51jfdma3fiz2ch";

  meta = {
    description = "Logic-less Ruby templating";
    homepage = "https://github.com/mustache/mustache";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
    mainProgram = "mustache";
  };
}
