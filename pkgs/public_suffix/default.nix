{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "public_suffix";
  version = "4.0.7";
  source.sha256 = "1f3knlwfwm05sfbaihrxm4g772b79032q14c16q4b38z8bi63qcb";

  meta = {
    description = "Domain name parser based on the Public Suffix List";
    homepage = "https://simonecarletti.com/code/publicsuffix-ruby";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
