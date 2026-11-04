{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "excon";
  version = "1.3.1";
  source.sha256 = "1fvxb016l7kkbmx7alw49b8d48f0cm7j8dkzbzj0al89nw2nixmx";

  meta = {
    description = "Usable, fast, simple HTTP 1.1 for Ruby";
    homepage = "https://github.com/excon/excon";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
