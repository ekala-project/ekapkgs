{
  buildRubyGem,
  lib,
  ruby,
  diff-lcs,
  rspec-support,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "rspec-mocks";
  version = "3.13.7";
  source.sha256 = "071bqrk2rblk3zq3jk1xxx0dr92y0szi5pxdm8waimxici706y89";

  propagatedBuildInputs = [
    diff-lcs
    rspec-support
  ];

  meta = {
    description = "RSpec test double framework";
    homepage = "https://github.com/rspec/rspec-mocks";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
