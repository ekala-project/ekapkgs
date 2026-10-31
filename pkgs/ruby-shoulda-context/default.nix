{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "shoulda-context";
  version = "2.0.0";
  source.sha256 = "0d1clcp92jv8756h09kbc55qiqncn666alx0s83za06q5hs4bpvs";

  meta = {
    description = "Context framework extracted from Shoulda";
    homepage = "https://github.com/thoughtbot/shoulda-context";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
