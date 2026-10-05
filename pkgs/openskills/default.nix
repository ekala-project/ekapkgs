{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage rec {
  npmDepsFetcherVersion = 2;
  pname = "openskills";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "numman-ali";
    repo = "openskills";
    tag = "v${version}";
    hash = "sha256-rOrLi43J+w6XBRZYYwlDPl8RqU7Zhr45B9UyP6Xarj0=";
  };

  npmDepsHash = "sha256-3ESEmIuCw/zdTW92Y7tJlRs5sKnu2+7O9HkeX9aKfS4=";
  makeCacheWritable = true;

  postInstall = ''
    ln -sf $out/lib/node_modules/openskills/dist/cli.js $out/bin/openskills
    patchShebangs $out/bin/openskills
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Universal skills loader for AI coding agents using the SKILL.md format";
    homepage = "https://github.com/numman-ali/openskills";
    changelog = "https://github.com/numman-ali/openskills/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "openskills";
    platforms = lib.platforms.all;
  };
}
