{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "net-scp";
  version = "4.2.0";
  source.sha256 = "0jfdm7s1dlagiavs6yn9d3iiiw256fl1xyjzydcfypcpry5si1bw";

  meta = {
    description = "Pure Ruby implementation of the SCP client protocol";
    homepage = "https://github.com/net-ssh/net-scp";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
