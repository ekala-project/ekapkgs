{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mustermann";
  version = "3.0.4";
  source.sha256 = "08ma2fmxlm6i7lih4mc3har2fzsbj1pl4hhva65kljf6nfvdryl5";

  meta = {
    description = "Pattern matching library for Sinatra-compatible URL patterns";
    homepage = "https://github.com/sinatra/mustermann";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
