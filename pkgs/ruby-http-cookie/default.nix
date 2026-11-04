{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "http-cookie";
  version = "1.0.8";
  source.sha256 = "19hsskzk5zpv14mnf07pq71hfk1fsjwfjcw616pgjjzjbi2f0kxi";

  meta = {
    description = "Ruby library to handle HTTP cookies";
    homepage = "https://github.com/sparklemotion/http-cookie";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
