{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "highline";
  version = "3.1.2";
  source.sha256 = "0jmvyhjp2v3iq47la7w6psrxbprnbnmzz0hxxski3vzn356x7jv7";

  meta = {
    description = "High-level IO library providing validation, type conversion, and menu systems for CLIs";
    homepage = "https://github.com/JEG2/highline";
    license = lib.licenses.ruby;
    platforms = ruby.meta.platforms;
  };
}
