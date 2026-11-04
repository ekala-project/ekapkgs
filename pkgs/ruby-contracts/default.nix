{
  lib,
  buildRubyGem,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "contracts";
  version = "0.17.3";
  source.sha256 = "1mqlhfsf53r5r5assnwzqq1ajbhwxcxniddpxjdhjiza2dj64bp7";

  meta = {
    description = "Contracts for Ruby, clearly expressing how code behaves";
    homepage = "https://github.com/egonSchiele/contracts.ruby";
    license = lib.licenses.bsd2;
    platforms = ruby.meta.platforms;
  };
}
