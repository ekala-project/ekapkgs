{
  buildRubyGem,
  lib,
  ruby,
  openssl,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "eventmachine";
  version = "1.2.7";
  source.sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";

  dontBuild = false;
  buildInputs = [ openssl ];

  meta = {
    description = "Fast, single-threaded engine for arbitrary network communications in Ruby";
    homepage = "https://github.com/eventmachine/eventmachine";
    license = with lib.licenses; [
      ruby
      gpl2
    ];
    platforms = ruby.meta.platforms;
  };
}
