{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "liquid";
  version = "5.14.0";
  source.sha256 = "0rbhq706lz7j1gzqnx2k6dw7mlkvacqs7izx7d6pm3755qmhq0p1";

  meta = {
    description = "Safe, customer-facing template language for flexible web apps";
    homepage = "https://shopify.github.io/liquid";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
