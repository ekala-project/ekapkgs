{
  buildRubyGem,
  lib,
  ruby,
  ruby-mini_portile2,
  zlib,
  libxml2,
  libxslt,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "nokogiri";
  version = "1.19.4";
  source.sha256 = "1d9safb4dly6qmc2g06444l0zifby52yy6j1a5fa1g4j3ihm3jah";

  propagatedBuildInputs = [ ruby-mini_portile2 ];

  buildFlags = [
    "--use-system-libraries"
    "--with-zlib-lib=${zlib.out}/lib"
    "--with-zlib-include=${zlib.dev}/include"
    "--with-xml2-lib=${libxml2.out}/lib"
    "--with-xml2-include=${libxml2.dev}/include/libxml2"
    "--with-xslt-lib=${libxslt.out}/lib"
    "--with-xslt-include=${libxslt.dev}/include"
    "--with-exslt-lib=${libxslt.out}/lib"
    "--with-exslt-include=${libxslt.dev}/include"
  ];

  meta = {
    description = "HTML, XML, SAX, and Reader parser with XPath and CSS selector support";
    homepage = "https://nokogiri.org/";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
