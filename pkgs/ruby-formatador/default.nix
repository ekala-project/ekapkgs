{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "formatador";
  version = "1.2.3";
  source.sha256 = "156qa2wiizmdalz6cim04yaasdz1q6c6k7yhnpdnrhn26f0qkyhr";

  meta = {
    description = "STDOUT text formatting";
    homepage = "https://github.com/geemus/formatador";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
