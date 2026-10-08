{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  rustc,
  cargo,
  rustPlatform,
  pkg-config,
  cmake,
  ninja,
  makeWrapper,
  autoPatchelfHook,
  zlib,
  python3,
  zig,
  libpulseaudio,
  pipewire,
}:

let
  versionData = {
    version = "18.4.6";
    hash = "sha256-3XCC12fRSk/iU/hKYk0v53HOMHG0Sk4R1GXzcFXnfYo=";
    cargoHash = "sha256-kB3UoRsL9Dv70iLrEO6nK+G3QQlWOgUdgIAx2ysK/4s=";
  };
  inherit (versionData) version hash cargoHash;

  platformsBySystem = {
    aarch64-darwin = {
      nativeLib = "libpi_natives.dylib";
      nodeTag = "darwin-arm64";
    };
    aarch64-linux = {
      nativeLib = "libpi_natives.so";
      nodeTag = "linux-arm64";
    };
    x86_64-linux = {
      nativeLib = "libpi_natives.so";
      nodeTag = "linux-x64";
    };
  };
  platform =
    platformsBySystem.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform for omp: ${stdenv.hostPlatform.system}");
  rustTarget = stdenv.hostPlatform.rust.rustcTarget;

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "oh-my-pi";
    tag = "v${version}";
    inherit hash;
  };

  # Common source manipulations: drop the robomp-web workspace (its devDeps
  # aren't needed) and strip range specifiers that would hit the registry.
  sourceManip = ''
    ROOT="$PWD" ${lib.getExe python3} -c "
    import json, re, os
    root = os.environ['ROOT']

    with open(f'{root}/package.json') as f:
        pkg = json.load(f)
    ws = pkg.get('workspaces', {})
    if isinstance(ws, dict) and 'packages' in ws:
        ws['packages'] = [w for w in ws['packages'] if 'robomp/web' not in w]
    elif isinstance(ws, list):
        pkg['workspaces'] = [w for w in ws if 'robomp/web' not in w]
    with open(f'{root}/package.json', 'w') as f:
        json.dump(pkg, f, indent=2)
        f.write('\n')

    with open(f'{root}/bun.lock') as f:
        text = re.sub(r',\s*([}\]])', r'\1', f.read())
    lock = json.loads(text)
    lock.get('workspaces', {}).pop('python/robomp/web', None)
    lock.get('packages', {}).pop('robomp-web', None)
    for k in list(lock.get('packages', {})):
        if k.startswith('robomp-web/'):
            del lock['packages'][k]
    with open(f'{root}/bun.lock', 'w') as f:
        json.dump(lock, f, indent=2)
        f.write('\n')
    "

    rm -rf python/robomp/web

    for f in package.json packages/*/package.json; do
      if [ -f "$f" ]; then
        sed -i 's/: "\^/: "/g; s/: "~/: "/g' "$f"
      fi
    done
    sed -i 's/: "\^/: "/g; s/: "~/: "/g' bun.lock
  '';

  node_modules = stdenv.mkDerivation {
    pname = "omp-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      python3
    ];

    dontConfigure = true;

    postPatch = sourceManip;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/repo
      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-sKRhnXGi2AUOxtifWfsLlczvoUTPdIZHb7gPAMnsg14=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "omp";
  inherit version src;

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "omp-${version}-cargo-vendor";
    inherit src;
    hash = cargoHash;
  };

  nativeBuildInputs = [
    bun
    rustc
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    pkg-config
    cmake
    ninja
    makeWrapper
    zig
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    zlib
    pipewire
  ];

  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  env = {
    RUSTC_BOOTSTRAP = 1;
    CARGO_PROFILE_RELEASE_LTO = "thin";
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = 16;
  };

  postPatch = sourceManip + ''
    cat > packages/stats/src/embedded-client.generated.txt <<'PLACEHOLDER'
    export const EMBEDDED_CLIENT_ARCHIVE_TAR_GZ_BASE64 = "";
    PLACEHOLDER
  '';

  dontUseCmakeConfigure = true;
  dontStrip = true;

  buildPhase = ''
    runHook preBuild

    cp -rf ${node_modules}/repo/. .
    chmod -R u+w .
    patchShebangs . || true

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      export LD_LIBRARY_PATH="${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
    ''}

    echo "Building Rust native addon..."
    cargo build --release -p pi-natives \
      ${lib.optionalString stdenv.hostPlatform.isLinux "--features wayland-pipewire"} \
      --target ${rustTarget} --target-dir target

    mkdir -p packages/natives/native
    cp target/${rustTarget}/release/${platform.nativeLib} \
       packages/natives/native/pi_natives.${platform.nodeTag}.node

    napiBin="$(pwd)/node_modules/.bin/napi"
    if [ -x "$napiBin" ]; then
      "$napiBin" build \
        --manifest-path crates/pi-natives/Cargo.toml \
        --package-json-path packages/natives/package.json \
        --platform --no-js --dts index.d.ts \
        -o packages/natives/native --release \
        || echo "napi CLI post-processing failed; using cargo output directly"
    fi

    if [ -f packages/natives/scripts/gen-enums.ts ] && \
       [ -f packages/natives/native/index.d.ts ]; then
      bun packages/natives/scripts/gen-enums.ts || true
    fi

    bun scripts/stamp-native-version.ts \
      packages/natives/native/pi_natives.${platform.nodeTag}.node --no-sign

    echo "Generating docs index..."
    bun packages/coding-agent/scripts/generate-docs-index.ts --generate

    echo "Generating embedded stats dashboard..."
    bun --cwd packages/stats scripts/generate-client-bundle.ts --generate
    bun ${./normalize-embedded-client.ts} \
      packages/stats/src/embedded-client.generated.txt

    echo "Generating embedded HTML-export tool-views..."
    bun --cwd packages/collab-web scripts/build-tool-views.ts

    echo "Compiling standalone binary..."
    (cd packages/coding-agent && bun ${./compile-standalone.ts})

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/omp $out/bin
    cp dist/omp $out/lib/omp/omp
    cp packages/natives/native/pi_natives.${platform.nodeTag}.node $out/lib/omp/

    makeWrapper $out/lib/omp/omp $out/bin/omp \
      --set PI_SKIP_VERSION_CHECK 1 \
      ${lib.optionalString stdenv.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          zlib
          stdenv.cc.cc.lib
          libpulseaudio
          pipewire
        ]
      }"}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME=$TMPDIR $out/bin/omp --smoke-test | grep -q "smoke-test: ok"
    BUN_BE_BUN=1 $out/lib/omp/omp -e \
      'if (Bun.version !== "${bun.version}" || typeof Bun.Image !== "function") process.exit(1)'
    runHook postInstallCheck
  '';

  meta = {
    description = "A terminal-based coding agent with multi-model support";
    homepage = "https://github.com/can1357/oh-my-pi";
    changelog = "https://github.com/can1357/oh-my-pi/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "omp";
    platforms = builtins.attrNames platformsBySystem;
  };
}
