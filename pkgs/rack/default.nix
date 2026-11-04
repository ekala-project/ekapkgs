{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rack";
  version = "3.2.8";
  source.sha256 = "1isfvhl6r55ddxwq8qsmn6zbljfmzjgq5zszjhm7mg1y8rgciv0z";

  meta = {
    description = "Minimal, modular and adaptable interface for developing web applications in Ruby";
    homepage = "https://github.com/rack/rack";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
