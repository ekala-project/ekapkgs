{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "faraday";
  version = "2.15.1";
  source.sha256 = "13r8mjqk8slscc8rxfhfrqglks131sb78ay4dklcafd7xm6ia247";

  meta = {
    description = "HTTP/REST API client library with pluggable middleware";
    homepage = "https://lostisland.github.io/faraday";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
