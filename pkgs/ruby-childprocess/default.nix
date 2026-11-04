{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "childprocess";
  version = "5.1.0";
  source.sha256 = "1v5nalaarxnfdm6rxb7q6fmc6nx097jd630ax6h9ch7xw95li3cs";

  meta = {
    description = "Managing child processes in Ruby";
    homepage = "https://github.com/enkessler/childprocess";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
