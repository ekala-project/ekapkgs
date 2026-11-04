{
  buildRubyGem,
  lib,
  ruby,
  sass-listen,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "sass";
  version = "3.7.4";
  source.sha256 = "0p95lhs0jza5l7hqci1isflxakz83xkj97lkvxl919is0lwhv2w0";

  propagatedBuildInputs = [ sass-listen ];

  meta = {
    description = "Sass extends CSS with nested rules, variables, mixins, and more";
    homepage = "https://sass-lang.com/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
