{
  buildRubyGem,
  lib,
  ruby,
  mime-types-data,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mime-types";
  version = "3.7.0";
  source.sha256 = "0mjyxl7c0xzyqdqa8r45hqg7jcw2prp3hkp39mdf223g4hfgdsyw";

  propagatedBuildInputs = [ mime-types-data ];

  meta = {
    description = "Library providing MIME content type definitions and registry";
    homepage = "https://github.com/mime-types/ruby-mime-types/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
