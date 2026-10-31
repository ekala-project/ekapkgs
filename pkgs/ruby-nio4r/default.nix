{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "nio4r";
  version = "2.7.4";
  source.sha256 = "1a9www524fl1ykspznz54i0phfqya4x45hqaz67in9dvw1lfwpfr";

  meta = {
    description = "New IO for Ruby - cross-platform asynchronous I/O";
    homepage = "https://github.com/socketry/nio4r";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
