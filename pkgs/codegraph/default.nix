{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage rec {
  npmDepsFetcherVersion = 2;
  pname = "codegraph";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "colbymchenry";
    repo = "codegraph";
    tag = "v${version}";
    hash = "sha256-Lr8J8/E/o4tECLe/uv0W2H6zD74+TH/431I2iIYZ2no=";
  };

  npmDepsHash = "sha256-ZUiYPsVpMtlvaMIcEH5Wo7EDwTiEq1Sz64NKAiiLzR0=";
  makeCacheWritable = true;

  postInstall = ''
    chmod +x $out/lib/node_modules/codegraph/dist/bin/codegraph.js
    patchShebangs $out/lib/node_modules/codegraph/dist/bin/codegraph.js
    ln -sf $out/lib/node_modules/codegraph/dist/bin/codegraph.js $out/bin/codegraph
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Semantic code intelligence for AI coding agents";
    homepage = "https://github.com/colbymchenry/codegraph";
    changelog = "https://github.com/colbymchenry/codegraph/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "codegraph";
    platforms = lib.platforms.all;
  };
}
