{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "execjs";
  version = "2.10.0";
  source.sha256 = "03a590q16nhqvfms0lh42mp6a1i41w41qpdnf39zjbq5y3l8pjvb";

  meta = {
    description = "Run JavaScript code from Ruby";
    homepage = "https://github.com/rails/execjs";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
