{
  buildRubyGem,
  lib,
  ruby,
  concurrent-ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "i18n";
  version = "1.14.7";
  source.sha256 = "03sx3ahz1v5kbqjwxj48msw3maplpp2iyzs22l4jrzrqh4zmgfnf";

  propagatedBuildInputs = [ concurrent-ruby ];

  meta = {
    description = "Internationalization (i18n) library for Ruby";
    homepage = "https://github.com/ruby-i18n/i18n";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
