{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "safe_yaml";
  version = "1.0.5";
  source.sha256 = "0j7qv63p0vqcd838i2iy2f76c3dgwzkiz1d1xkg7n0pbnxj2vb56";

  meta = {
    description = "Parse YAML safely";
    homepage = "https://github.com/dtao/safe_yaml";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
