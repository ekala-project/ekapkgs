{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "diff-lcs";
  version = "1.6.2";
  source.sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";

  meta = {
    description = "Diff::LCS computes the difference between two Enumerable sequences";
    homepage = "https://github.com/halostatue/diff-lcs";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
