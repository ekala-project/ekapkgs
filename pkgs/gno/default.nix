{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  sqlite,
  autoPatchelfHook,
}:

bun.buildPackage {
  pname = "gno";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "gmickel";
    repo = "gno";
    tag = "v2.9.0";
    hash = "sha256-pHtJjuBXi6W9TWxXYIq8e/OmVv/J6P225reKpzzmLsA=";
  };

  node_modulesHash = "sha256-G5+3dmh3EBpzTlnaZIzdiUjHVCJWqF5KrpOgc/TJ61E=";
  node_modulesAttrs.buildPhase = ''
    runHook preBuild
    export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
    export LC_ALL=C.UTF-8
    bun install --frozen-lockfile --ignore-scripts --no-progress
    runHook postBuild
  '';

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ sqlite ] ++ lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

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

  bunBuildCommand = ''
    patchShebangs node_modules || true
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/gno $out/bin

    cp -r node_modules src vendor package.json $out/lib/gno/

    patch -p1 -d $out/lib/gno < ${./node-llama-cpp-detectGlibc.patch}

    makeWrapper ${lib.getExe bun} $out/bin/gno \
      --add-flags "$out/lib/gno/src/index.ts" \
      --set DYLD_LIBRARY_PATH "${sqlite}/lib" \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ sqlite ]}"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME=$(mktemp -d) $out/bin/gno --help | grep -qi "gno"
    runHook postInstallCheck
  '';

  meta = {
    description = "Local-first knowledge engine with hybrid search, RAG Q&A, and MCP server integration";
    homepage = "https://github.com/gmickel/gno";
    changelog = "https://github.com/gmickel/gno/releases/tag/v2.9.0";
    license = lib.licenses.mit;
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryNativeCode
    ];
    platforms = lib.platforms.unix;
    mainProgram = "gno";
  };
}
