{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "zeitwerk";
  version = "2.8.3";
  source.sha256 = "1rcjpgyzmdxp8rdw466156fmr588k9q1wg8j42g0dkk7hid1519c";

  meta = {
    description = "Efficient and thread-safe code loader for Ruby";
    homepage = "https://github.com/fxn/zeitwerk";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
