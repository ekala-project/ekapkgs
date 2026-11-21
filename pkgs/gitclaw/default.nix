{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  npmDepsFetcherVersion = 2;
  pname = "gitclaw";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "open-gitagent";
    repo = "gitagent";
    tag = "v${version}";
    hash = "sha256-Scay09se0ZrGoMA1uRKza79au2jtVHuQqnmbAyh7B+Y=";
  };

  npmDepsHash = "sha256-H+giDeP2XmP5UFeQMqKZNJNl/owp6GclUaVGA6Nkfn8=";
  makeCacheWritable = true;

  # @googleworkspace/cli's postinstall downloads a prebuilt `gws` binary from
  # GitHub releases, which the sandbox blocks. Nothing in src/ imports it.
  npmFlags = [ "--ignore-scripts" ];
  preFixup = ''
    rm -f $out/lib/node_modules/gitclaw/node_modules/.bin/gws
    rm -rf $out/lib/node_modules/gitclaw/node_modules/@googleworkspace
  '';

  meta = {
    description = "Universal git-native multimodal AI agent (formerly gitagent)";
    homepage = "https://github.com/open-gitagent/gitagent";
    changelog = "https://github.com/open-gitagent/gitagent/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "gitclaw";
    platforms = lib.platforms.all;
  };
}
