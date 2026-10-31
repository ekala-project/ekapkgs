{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "net-ssh";
  version = "8.0.4";
  source.sha256 = "06xzz54c97b7hxp01fjp9x34wh6wwlv95dh4vmw432c2zrsid7ln";

  meta = {
    description = "Pure-Ruby implementation of the SSH2 client protocol";
    homepage = "https://github.com/net-ssh/net-ssh";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
