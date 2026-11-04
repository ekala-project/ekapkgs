{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "netrc";
  version = "0.11.0";
  source.sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";

  meta = {
    description = "Library for reading and writing netrc files";
    homepage = "https://github.com/geemus/netrc";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
