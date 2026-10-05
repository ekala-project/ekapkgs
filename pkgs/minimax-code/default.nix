{
  lib,
  buildNpmPackage,
  fetchurl,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.5.10";

  srcWithLock = runCommand "minimax-code-src-with-lock" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@minimax-ai/code/-/code-${version}.tgz";
        hash = "sha256-mw4wgSVtzBlWQAr8iJt8dbC1/J5vQFXkWwxbYKR2FJw=";
      }
    } -C $out --strip-components=1
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  pname = "minimax-code";
  inherit version;
  src = srcWithLock;

  npmDepsHash = "sha256-iluASXcd7MRAdYlTQ6PzwUUnXi/ZZdkCbh/uUPGehmc=";
  npmDepsFetcherVersion = 2;

  # root postinstall and @vscode/ripgrep hit the network
  npmFlags = [ "--ignore-scripts" ];
  preBuild = "npm rebuild --ignore-scripts=false better-sqlite3";
  dontNpmBuild = true;

  postInstall = ''
    find $out -path '*/better-sqlite3/build/*' ! -name better_sqlite3.node -type f -delete
    for b in cli mcode-tools; do
      chmod +x $out/lib/node_modules/minimax-code/$b.js
      patchShebangs $out/lib/node_modules/minimax-code/$b.js
    done
    ln -sf $out/lib/node_modules/minimax-code/cli.js $out/bin/mcode
    ln -sf $out/lib/node_modules/minimax-code/mcode-tools.js $out/bin/mcode-tools
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Open-source coding agent for your terminal, powered by MiniMax";
    homepage = "https://github.com/MiniMax-AI/minimax-code";
    changelog = "https://github.com/MiniMax-AI/minimax-code/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "mcode";
    platforms = lib.platforms.all;
  };
}
