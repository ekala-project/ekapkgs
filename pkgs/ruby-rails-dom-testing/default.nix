{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rails-dom-testing";
  version = "2.3.0";
  source.sha256 = "07awj8bp7jib54d0khqw391ryw8nphvqgw4bb12cl4drlx9pkk4a";

  meta = {
    description = "DOM and selector assertions for Rails applications";
    homepage = "https://github.com/rails/rails-dom-testing";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
