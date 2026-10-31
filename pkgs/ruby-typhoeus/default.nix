{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "typhoeus";
  version = "1.7.1";
  source.sha256 = "0zzfq99zrnx4dimlcg681n404jrwmwj6nhy98x4y627fhzbvdp46";

  meta = {
    description = "Parallel HTTP request library wrapping libcurl";
    homepage = "https://github.com/typhoeus/typhoeus";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
