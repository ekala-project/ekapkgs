{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "httpclient";
  version = "2.9.0";
  source.sha256 = "1j4qwj1nv66v3n9s4xqf64x2galvjm630bwa5xngicllwic5jr2b";

  meta = {
    description = "HTTP client library with WebDAV and cookie support";
    homepage = "https://github.com/nahi/httpclient";
    license = lib.licenses.ruby;
    platforms = ruby.meta.platforms;
  };
}
