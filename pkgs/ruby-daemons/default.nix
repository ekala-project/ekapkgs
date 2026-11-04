{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "daemons";
  version = "1.4.1";
  source.sha256 = "07cszb0zl8mqmwhc8a2yfg36vi6lbgrp4pa5bvmryrpcz9v6viwg";

  meta = {
    description = "Toolkit for daemonizing Ruby processes";
    homepage = "https://github.com/thuehlinger/daemons";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
