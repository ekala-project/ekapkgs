{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "domain_name";
  version = "0.6.20240107";
  source.sha256 = "0cyr2xm576gqhqicsyqnhanni47408w2pgvrfi8pd13h2li3nsaz";

  meta = {
    description = "Domain Name manipulation library for Ruby";
    homepage = "https://github.com/knu/ruby-domain_name";
    license = lib.licenses.bsd2;
    platforms = ruby.meta.platforms;
  };
}
