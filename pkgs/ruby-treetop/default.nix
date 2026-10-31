{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "treetop";
  version = "1.6.18";
  source.sha256 = "1nl3q5ai7ikaa5sjdbspfa4njbrdvf7898zkplmalln6y4r3y153";

  meta = {
    description = "A Parsing Expression Grammar (PEG) Parser generator DSL for Ruby";
    homepage = "https://github.com/cjheath/treetop";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
