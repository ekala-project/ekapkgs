{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "mdl";
  gemdir = ./.;
  exes = [ "mdl" ];
  meta = {
    description = "Tool to check markdown files and flag style issues";
    homepage = "https://github.com/markdownlint/markdownlint";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
