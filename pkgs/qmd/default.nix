{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeWrapper,
  sqlite,
  autoPatchelfHook,
}:

let
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "qmd";
    tag = "v${version}";
    hash = "sha256-/7Z94r/9rXqzKlz/YkB6/nToSCPamV4Dnxm8EhelTDo=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "qmd-node_modules";
    inherit version src;

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      cp package.json $out/package.json
      [ -f bun.lock ] && cp bun.lock $out/ || true
      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-B4M7Uiocy4F7c7IncERU5QyNNAal+cgNDVohybwRNJA=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "qmd";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libc.musl-aarch64.so.1"
    "libcudart.so.12"
    "libcublas.so.12"
    "libcudart.so.13"
    "libcublas.so.13"
    "libcuda.so.1"
    "libvulkan.so.1"
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    chmod -R u+w node_modules
    patchShebangs node_modules || true
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/qmd $out/bin

    cp -r node_modules src package.json $out/lib/qmd/

    patch -p1 -d $out/lib/qmd < ${./node-llama-cpp-detectGlibc.patch}
    patch -p1 -d $out/lib/qmd < ${./node-llama-cpp-nix-compat.patch}

    makeWrapper ${bun}/bin/bun $out/bin/qmd \
      --add-flags "$out/lib/qmd/src/cli/qmd.ts" \
      --set DYLD_LIBRARY_PATH "${sqlite}/lib" \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ sqlite ]}"

    runHook postInstall
  '';

  meta = {
    description = "mini cli search engine for your docs, knowledge bases, meeting notes, whatever.";
    homepage = "https://github.com/tobi/qmd";
    changelog = "https://github.com/tobi/qmd/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryNativeCode
    ];
    platforms = lib.platforms.unix;
    mainProgram = "qmd";
  };
}
