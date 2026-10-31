{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "websocket-driver";
  version = "0.8.2";
  source.sha256 = "0ij19k6034x0c4hw0ywa7wnk5s912r8aq0hhjss10d5z36q5dicp";

  meta = {
    description = "WebSocket protocol handler with pluggable I/O";
    homepage = "https://github.com/faye/websocket-driver-ruby";
    license = lib.licenses.asl20;
    platforms = ruby.meta.platforms;
  };
}
