{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mini_portile2";
  version = "2.8.9";
  source.sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";

  meta = {
    description = "Simple autoconf and cmake builder for developers";
    homepage = "https://github.com/flavorjones/mini_portile";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
