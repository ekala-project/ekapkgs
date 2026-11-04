{
  buildRubyGem,
  lib,
  ruby,
  rb-fsevent,
  rb-inotify,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "listen";
  version = "3.10.1";
  source.sha256 = "0g3q0hnxnskhlchlyghxdc5dk41pzxr27pd4gms4iwspas2k4gsc";

  propagatedBuildInputs = [
    rb-fsevent
    rb-inotify
  ];

  meta = {
    description = "Listens to file modifications and notifies you about the changes";
    homepage = "https://github.com/guard/listen";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
