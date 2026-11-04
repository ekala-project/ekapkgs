{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "timecop";
  version = "0.9.11";
  source.sha256 = "0hkmrkg46qvfla31734d5y28q422z5kfgb41yy2227q4wp34sa21";

  meta = {
    description = "A gem providing time travel and time freezing capabilities for testing";
    homepage = "https://github.com/travisjeffery/timecop";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
