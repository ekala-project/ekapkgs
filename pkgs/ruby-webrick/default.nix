{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "webrick";
  version = "1.9.2";
  source.sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";

  meta = {
    description = "HTTP server toolkit for Ruby";
    homepage = "https://github.com/ruby/webrick";
    license = lib.licenses.bsd2;
    platforms = ruby.meta.platforms;
  };
}
