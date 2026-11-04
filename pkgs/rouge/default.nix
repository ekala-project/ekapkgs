{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rouge";
  version = "5.1.0";
  source.sha256 = "0ljlr1da64kx3mimpzb4x2yczk08b0sg04h2ji3m2zxb88l66z5p";

  meta = {
    description = "Simple, easy-to-extend drop-in replacement for pygments";
    homepage = "http://rouge.jneen.net/";
    license = with lib.licenses; [
      mit
      bsd2
    ];
    platforms = ruby.meta.platforms;
  };
}
