{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "multipart-post";
  version = "2.4.1";
  source.sha256 = "1a5lrlvmg2kb2dhw3lxcsv6x276bwgsxpnka1752082miqxd0wlq";

  meta = {
    description = "Multipart form post accessory for Net::HTTP";
    homepage = "https://github.com/socketry/multipart-post";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
