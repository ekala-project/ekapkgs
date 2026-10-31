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
  gemName = "sass-listen";
  version = "4.0.0";
  source.sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";

  propagatedBuildInputs = [
    rb-fsevent
    rb-inotify
  ];

  meta = {
    description = "This fork of guard/listen provides a stable API for users of the ruby Sass CLI";
    homepage = "https://github.com/sass/listen";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
