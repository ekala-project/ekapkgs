{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mocha";
  version = "2.7.1";
  source.sha256 = "0lgqyxxdxgfik77a7lk2hjkr6flimgxr4gcbg3y7bg1ybn6m6zcg";

  meta = {
    description = "Mocking and stubbing library for Ruby";
    homepage = "https://mocha.jamesmead.org/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
