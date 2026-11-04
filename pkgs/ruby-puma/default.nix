{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "puma";
  version = "8.0.2";
  source.sha256 = "1yw6nvkvddriacmva8hm0za0961d6j96dm7zm6748rmyzcfqgvf8";

  meta = {
    description = "Fast, concurrent web server for Ruby and Rack";
    homepage = "https://puma.io";
    license = lib.licenses.bsd3;
    platforms = ruby.meta.platforms;
  };
}
