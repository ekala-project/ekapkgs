{
  lib,
  buildNpmPackage,
  fetchurl,
  runCommand,
  jq,
  nodejs,
  fd,
  ripgrep,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "5.1.7";

  srcWithLock = runCommand "omo-ai-src-with-lock" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/omo-ai/-/omo-ai-${version}.tgz";
        hash = "sha256-a5ZChked9RiltB9qmNu7cAn72+0LUVwcI6Z5l+ZIyNc=";
      }
    } -C $out --strip-components=1
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage rec {
  npmDepsFetcherVersion = 2;
  pname = "omo-ai";
  inherit version;
  src = srcWithLock;

  npmDepsHash = "sha256-7H4jsIm1T8b9En1Y0gBTFyiqWIiUhU5+Zb3ECtKNdgM=";

  dontNpmBuild = true;
  makeCacheWritable = true;

  nativeBuildInputs = [
    jq
    makeWrapper
  ];

  postInstall = ''
    for pkgjson in $(find $out/lib/node_modules -maxdepth 3 -name package.json | grep -vE 'node_modules/[^/]+/node_modules'); do
      pkgdir=$(dirname "$pkgjson")
      ${lib.getExe jq} -r '(.bin // {}) | to_entries[] | "\(.key)\t\(.value)"' "$pkgjson" 2>/dev/null | while IFS=$'\t' read -r name target; do
        [ -z "$name" ] && continue
        src="$pkgdir/$target"
        [ -f "$src" ] || continue
        chmod +x "$src"
        patchShebangs "$src"
        ln -sf "$src" "$out/bin/$name"
      done
    done
    wrapProgram "$out/bin/omo" \
      --prefix PATH : ${lib.makeBinPath [ nodejs fd ripgrep ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Oh My OpenAgent standalone coding agent";
    homepage = "https://github.com/code-yeongyu/oh-my-openagent";
    changelog = "https://github.com/code-yeongyu/oh-my-openagent/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "omo";
    platforms = lib.platforms.all;
  };
}
