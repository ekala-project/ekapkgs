{
  lib,
  buildRubyGem,
  ruby,
  curl,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "curb";
  version = "1.4.1";
  source.sha256 = "0388a77riybhlck26nv55nzxfklij8zb6wmca9cd2zywvw7ncvpj";

  buildInputs = [ curl ];

  meta = {
    description = "Ruby-language bindings for libcurl";
    homepage = "https://github.com/taf2/curb";
    license = lib.licenses.ruby;
    platforms = ruby.meta.platforms;
  };
}
