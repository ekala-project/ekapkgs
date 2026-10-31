{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "simplecov-html";
  version = "0.13.2";
  source.sha256 = "0ikjfwydgs08nm3xzc4cn4b6z6rmcrj2imp84xcnimy2wxa8w2xx";

  meta = {
    description = "Default HTML formatter for SimpleCov code coverage tool";
    homepage = "https://github.com/simplecov-ruby/simplecov-html";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
