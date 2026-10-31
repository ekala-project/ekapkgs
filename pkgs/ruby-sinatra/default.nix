{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "sinatra";
  version = "4.2.1";
  source.sha256 = "103h6wjpcqp3i034hi44za2v365yz7qk9s5df8lmasq43nqvkbmp";

  meta = {
    description = "DSL for quickly creating web applications in Ruby";
    homepage = "https://sinatrarb.com/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
