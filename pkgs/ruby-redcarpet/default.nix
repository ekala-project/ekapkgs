{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "redcarpet";
  version = "3.6.0";
  source.sha256 = "1sg9sbf9pm91l7lac7fs4silabyn0vflxwaa2x3lrzsm0ff8ilca";

  meta = {
    description = "Safe Markdown to (X)HTML processor";
    homepage = "https://github.com/vmg/redcarpet";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
