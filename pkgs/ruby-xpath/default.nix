{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "xpath";
  version = "3.2.0";
  source.sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";

  meta = {
    description = "Ruby DSL for generating XPath expressions";
    homepage = "https://github.com/teamcapybara/xpath";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
