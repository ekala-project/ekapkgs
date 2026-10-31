{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "webmock";
  version = "3.34.0";
  source.sha256 = "0cvbyhsahjmq0a3gqzg5glwjx7l6dfmdmbmcjbalh0f0r2fx5vkj";

  meta = {
    description = "Library for stubbing HTTP requests and setting expectations on HTTP requests";
    homepage = "https://github.com/bblimke/webmock";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
