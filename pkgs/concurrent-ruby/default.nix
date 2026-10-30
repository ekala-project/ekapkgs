{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "concurrent-ruby";
  version = "1.3.8";
  source.sha256 = "sha256-svG+g26WjMx4zPzid+p5xyqIYz8iMGeCwW/yP7QV0eE=";

  meta = {
    description = "Modern concurrency tools for Ruby";
    homepage = "https://github.com/ruby-concurrency/concurrent-ruby";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
