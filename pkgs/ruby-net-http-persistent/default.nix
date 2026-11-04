{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "net-http-persistent";
  version = "4.0.8";
  source.sha256 = "1rk03449disq3azyiymv1c3qnpqr6cxawgq556rkf5b9klqyhggg";

  meta = {
    description = "Manages persistent connections using Net::HTTP";
    homepage = "https://github.com/drbrain/net-http-persistent";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
