{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "crack";
  version = "1.0.1";
  source.sha256 = "0zjcdl5i6lw508r01dym05ibhkc784cfn93m1d26c7fk1hwi0jpz";

  meta = {
    description = "Really simple JSON and XML parsing, ripped from Merb and Rails";
    homepage = "https://github.com/jnunemaker/crack";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
