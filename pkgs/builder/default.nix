{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "builder";
  version = "3.3.0";
  source.sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";

  meta = {
    description = "Provide a simple way to create XML markup and data structures";
    homepage = "https://github.com/jimweirich/builder";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
