{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "docile";
  version = "1.4.1";
  source.sha256 = "07pj4z3h8wk4fgdn6s62vw1lwvhj0ac0x10vfbdkr9xzk7krn5cn";

  meta = {
    description = "Turns any Ruby object into a DSL";
    homepage = "https://ms-ati.github.io/docile/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
