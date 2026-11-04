{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "text";
  version = "1.3.1";
  source.sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";

  meta = {
    description = "A collection of text algorithms: Levenshtein, Soundex, Metaphone, Double Metaphone, Porter Stemming";
    homepage = "https://github.com/threedaymonk/text";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
