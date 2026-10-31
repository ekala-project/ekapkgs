{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "polyglot";
  version = "0.3.5";
  source.sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";

  meta = {
    description = "Enables Ruby modules to register custom loaders for file types";
    homepage = "https://github.com/cjheath/polyglot";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
