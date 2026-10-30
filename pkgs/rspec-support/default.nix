{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rspec-support";
  version = "3.13.6";
  source.sha256 = "1cmgz34hwj5s3jwxhyl8mszs24nci12ffbrmr5jb1si74iqf739f";

  meta = {
    description = "Support utilities for RSpec gems";
    homepage = "https://github.com/rspec/rspec-support";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
