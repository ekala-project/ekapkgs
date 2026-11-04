{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "websocket-extensions";
  version = "0.1.5";
  source.sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";

  meta = {
    description = "Generic extension manager for WebSocket connections";
    homepage = "https://github.com/faye/websocket-extensions-ruby";
    license = lib.licenses.asl20;
    platforms = ruby.meta.platforms;
  };
}
