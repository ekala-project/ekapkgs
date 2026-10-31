{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rails-html-sanitizer";
  version = "1.6.2";
  source.sha256 = "0q55i6mpad20m2x1lg5pkqfpbmmapk0sjsrvr1sqgnj2hb5f5z1m";

  meta = {
    description = "HTML sanitization for Rails applications";
    homepage = "https://github.com/rails/rails-html-sanitizer";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
