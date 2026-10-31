{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "msgpack";
  version = "1.8.0";
  source.sha256 = "0cnpnbn2yivj9gxkh8mjklbgnpx6nf7b8j2hky01dl0040hy0k76";

  meta = {
    description = "MessagePack implementation for Ruby";
    homepage = "https://msgpack.org/";
    license = lib.licenses.asl20;
    platforms = ruby.meta.platforms;
  };
}
