{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "temple";
  version = "0.10.3";
  source.sha256 = "0fwia5hvc1xz9w7vprzjnsym3v9j5l9ggdvy70jixbvpcpz4acfz";

  meta = {
    description = "Template compilation framework in Ruby";
    homepage = "https://github.com/judofyr/temple";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
