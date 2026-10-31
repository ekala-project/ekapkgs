{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "unf_ext";
  version = "0.0.9.1";
  source.sha256 = "1sf6bxvf6x8gihv6j63iakixmdddgls58cpxpg32chckb2l18qcj";

  meta = {
    description = "Unicode Normalization Form support library for CRuby";
    homepage = "https://github.com/knu/ruby-unf_ext";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
