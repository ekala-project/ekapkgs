{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "hoe";
  version = "4.7.2";
  source.sha256 = "1bnv5d9gj9fnwdjqq02f2qyvcm7iiq8qrdq4hhw61y7zs8qhv7kn";

  meta = {
    description = "Rake/rubygems helper for project Rakefiles";
    homepage = "https://zenspider.com/projects/hoe.html";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
