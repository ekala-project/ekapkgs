{
  lib,
  stdenv,
  fetchurl,
  gitMinimal,
  jq,
  nodejs,
  python3,
  makeWrapper,
  runCommand,
}:

let
  version = "0.44.0";

  src = runCommand "bb-app-src" { nativeBuildInputs = [ jq ]; } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/bb-app/-/bb-app-${version}.tgz";
        hash = "sha256-W2V+KkIJcCyb95PCGyzu6D0Vihdu6AOB+N8eQoRXkqI=";
      }
    } -C $out --strip-components=1
    ${lib.getExe jq} 'del(.devDependencies)' $out/package.json > $out/package.json.tmp
    mv $out/package.json.tmp $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "bb-app";
  inherit version src;

  # The published package already contains the application, server, host
  # daemon, and web UI bundles.
  dontNpmBuild = true;

  nativeBuildInputs = [
    makeWrapper
    python3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  # Compile the native modules explicitly for Nix's Node.js and host platform.
  buildPhase = ''
    runHook preBuild
    npm_config_build_from_source=true \
      npm rebuild @parcel/watcher better-sqlite3 node-pty
    runHook postBuild
  '';

  postInstall = ''
    packageDir=$out/lib/node_modules/bb-app

    # Prefer the watcher built above over npm's platform-specific prebuilds.
    find "$packageDir/node_modules/@parcel" -mindepth 1 -maxdepth 1 \
      -type d -name 'watcher-*' -exec rm -rf {} +

    rm -rf \
      "$packageDir/node_modules/@parcel/watcher/build/Release/obj.target" \
      "$packageDir/node_modules/better-sqlite3/build/Release/obj.target" \
      "$packageDir/node_modules/node-pty/build/Release/obj.target"

    for program in bb bb-app bb-host-daemon bb-server; do
      wrapProgram "$out/bin/$program" \
        --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
    done
  '';

  meta = {
    description = "Agentic IDE for orchestrating coding agents";
    homepage = "https://getbb.app";
    changelog = "https://getbb.app/changelog#${version}";
    downloadPage = "https://www.npmjs.com/package/bb-app";
    license = lib.licenses.mit;
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode
      lib.sourceTypes.binaryNativeCode
    ];
    mainProgram = "bb-app";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
