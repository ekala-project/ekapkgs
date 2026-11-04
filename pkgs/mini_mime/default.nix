{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mini_mime";
  version = "1.1.5";
  source.sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";

  meta = {
    description = "A minimal MIME type library";
    homepage = "https://github.com/discourse/mini_mime";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
