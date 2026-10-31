{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "marcel";
  version = "2.1.0";
  source.sha256 = "04imrizh9prwlm110v42ppi51kl1x59f1vzf65im2znw25qk5c7q";

  meta = {
    description = "Simple mime type detection using magic numbers, filenames, and extensions";
    homepage = "https://github.com/rails/marcel";
    license = with lib.licenses; [ mit asl20 ];
    platforms = ruby.meta.platforms;
  };
}
