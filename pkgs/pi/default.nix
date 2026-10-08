{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  nodejs,
  bun,
  fd,
  ripgrep,
  makeWrapper,
  autoPatchelfHook,
  libxcb,
}:

let
  versionData = {
    version = "0.99.2";
    sourceHash = "sha256-W7GXvtjka1NSp6lA3chow1hyWyFPJ/OtTTPnfumDJVg=";
    npmDepsHash = "sha256-3RGSzm6ALmTbxpG+sdhtYWGeCNvXENEQ7nMvFGx8NeQ=";
  };
  version = versionData.version;

  nativeTargets = {
    aarch64-darwin = "darwin-arm64";
    aarch64-linux = "linux-arm64";
    x86_64-linux = "linux-x64";
  };
  nativeTarget = nativeTargets.${stdenv.hostPlatform.system}
    or (throw "Unsupported Pi platform: ${stdenv.hostPlatform.system}");
  nativePlatform = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";
  nativeFile = "${nativePlatform}-platform${lib.optionalString stdenv.hostPlatform.isLinux "-x11"}.node";

  srcWithLock = runCommand "pi-src-with-lock" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
        hash = versionData.sourceHash;
      }
    } -C $out --strip-components=1
    rm -f $out/npm-shrinkwrap.json
    cp ${./package-lock.json} $out/package-lock.json
    sed -i '/"@earendil-works\/pi-protocol"/a\    "@earendil-works\/pi-server": "^\${version}",' $out/package.json
    grep -q pi-server $out/package.json
  '';
in
nodejs.buildNpmApplication {
  pname = "pi";
  inherit version;
  src = srcWithLock;

  dontNpmBuild = true;

  nativeBuildInputs = [ bun ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  preInstall = ''
    # Upstream embeds the worker as ./src/utils/image-resize-worker.ts and
    # loads it by that path at runtime; the npm tarball only ships dist/.
    mkdir -p src/utils src/modes src/core
    echo 'import "../../dist/utils/image-resize-worker.js";' > src/utils/image-resize-worker.ts
    ln -s ../../dist/modes/interactive src/modes/interactive
    ln -s ../../dist/core/export-html src/core/export-html

    bun build --compile ./dist/bun/cli.js ./src/utils/image-resize-worker.ts --outfile dist/pi
  '';

  postInstall = ''
    pkgdir=$out/libexec/pi

    rm -rf "$out/lib" "$out/bin"
    mkdir -p "$out/bin" "$pkgdir/theme" "$pkgdir/assets"
    cp dist/pi "$pkgdir/"
    cp package.json README.md CHANGELOG.md "$pkgdir/"
    mkdir -p "$pkgdir/native/${nativePlatform}/prebuilds"
    cp -r node_modules/@earendil-works/pi-tui/native/${nativePlatform}/prebuilds/${nativeTarget} \
      "$pkgdir/native/${nativePlatform}/prebuilds/"
    cp node_modules/@silvia-odwyer/photon-node/photon_rs_bg.wasm "$pkgdir/"
    cp dist/modes/interactive/theme/*.json "$pkgdir/theme/"
    cp dist/modes/interactive/assets/* "$pkgdir/assets/"
    cp -r dist/core/export-html "$pkgdir/"
    cp -r docs examples "$pkgdir/"
    find "$pkgdir" -name '*.js' -exec chmod -x {} +

    makeWrapper "$pkgdir/pi" "$out/bin/pi" \
      --prefix PATH : ${lib.makeBinPath [ fd ripgrep ]} \
      --set PI_PACKAGE_DIR "$pkgdir" \
      --set PI_SKIP_VERSION_CHECK 1 \
      --set PI_TELEMETRY 0
  '';

  # The CLI's --version output does not match the package version format.
  doInstallCheck = false;

  meta = {
    description = "A terminal-based coding agent with multi-model support";
    homepage = "https://github.com/earendil-works/pi";
    changelog = "https://github.com/earendil-works/pi/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "pi";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
