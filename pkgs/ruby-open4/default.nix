{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "open4";
  version = "1.3.4";
  source.sha256 = "1cgls3f9dlrpil846q0w7h66vsc33jqn84nql4gcqkk221rh7px1";

  meta = {
    description = "Open child process with handles on pid, stdin, stdout, and stderr";
    homepage = "https://github.com/ahoward/open4";
    license = lib.licenses.ruby;
    platforms = ruby.meta.platforms;
  };
}
