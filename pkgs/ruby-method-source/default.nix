{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "method_source";
  version = "1.1.0";
  source.sha256 = "1igmc3sq9ay90f8xjvfnswd1dybj1s3fi0dwd53inwsvqk4h24qq";

  meta = {
    description = "Retrieve the source code for a method";
    homepage = "https://github.com/banister/method_source";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
