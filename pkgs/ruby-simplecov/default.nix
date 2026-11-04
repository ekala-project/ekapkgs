{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "simplecov";
  version = "1.3.2";
  source.sha256 = "118fdpg7h1ny1fz6kmiyz6gccvwmb23h6bhsi1hdpf7ib4byq8ia";

  meta = {
    description = "Code coverage analysis tool for Ruby";
    homepage = "https://github.com/simplecov-ruby/simplecov";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
