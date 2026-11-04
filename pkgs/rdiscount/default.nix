{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rdiscount";
  version = "2.2.7.5";
  source.sha256 = "0bvly41mr15gjnzqz5yz9kypzn1jdnygdbr8p407hr8m9h09xfxc";

  meta = {
    description = "Fast implementation of Gruber's Markdown in C";
    homepage = "http://dafoster.net/projects/rdiscount/";
    license = lib.licenses.bsd3;
    platforms = ruby.meta.platforms;
  };
}
