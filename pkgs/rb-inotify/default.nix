{
  buildRubyGem,
  lib,
  ruby,
  ruby-ffi,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rb-inotify";
  version = "0.11.1";
  source.sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";

  propagatedBuildInputs = [ ruby-ffi ];

  meta = {
    description = "A Ruby wrapper for Linux inotify, using FFI";
    homepage = "https://github.com/guard/rb-inotify";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
