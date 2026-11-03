{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage rec {
  npmDepsFetcherVersion = 2;
  pname = "oh-my-claudecode";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "yeachan-heo";
    repo = "oh-my-claudecode";
    tag = "v${version}";
    hash = "sha256-k4ffJyfDH6k5UqYHxhAQOFYj6E23WFIR0CYmxhGVlos=";
  };

  npmDepsHash = "sha256-JAs3l2TKr4FG4jTgFSaH/wYKDXXzatpMANIbF0xJHmA=";
  makeCacheWritable = true;

  # Native deps (better-sqlite3, @ast-grep/napi) need rebuild skipped.
  npmFlags = [ "--ignore-scripts" ];

  postInstall = ''
    chmod +x $out/lib/node_modules/oh-my-claudecode/bin/oh-my-claudecode.js
    patchShebangs $out/lib/node_modules/oh-my-claudecode/bin/oh-my-claudecode.js
    ln -sf $out/lib/node_modules/oh-my-claudecode/bin/oh-my-claudecode.js $out/bin/oh-my-claudecode
    ln -sf $out/lib/node_modules/oh-my-claudecode/bin/oh-my-claudecode.js $out/bin/omc
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Multi-agent orchestration system for Claude Code";
    homepage = "https://github.com/yeachan-heo/oh-my-claudecode";
    changelog = "https://github.com/yeachan-heo/oh-my-claudecode/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "oh-my-claudecode";
    platforms = lib.platforms.all;
  };
}
