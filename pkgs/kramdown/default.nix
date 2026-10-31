{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "kramdown";
  version = "2.5.2";
  source.sha256 = "1yh2gwpwhh0p4vc0aabzn0hb55av0wkcq3gh3w8zkdk69hh4598v";

  meta = {
    description = "Fast, pure Ruby Markdown parser using a strict syntax definition";
    homepage = "http://kramdown.gettalong.org";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
