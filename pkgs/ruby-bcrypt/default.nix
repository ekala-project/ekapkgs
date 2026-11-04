{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bcrypt";
  version = "3.1.22";
  source.sha256 = "0clhya4p8lhjj7hp31inp321wgzb0b5wbwppmya5sw1dikl7400z";

  meta = {
    description = "Secure hash algorithm designed by The OpenBSD project for hashing passwords";
    homepage = "https://github.com/bcrypt-ruby/bcrypt-ruby";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
