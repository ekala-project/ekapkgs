{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  sqlite,
  autoPatchelfHook,
}:

bun.buildPackage {
  pname = "qmd";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "qmd";
    tag = "v2.8.3";
    hash = "sha256-/7Z94r/9rXqzKlz/YkB6/nToSCPamV4Dnxm8EhelTDo=";
  };

  node_modulesHash = "sha256-B4M7Uiocy4F7c7IncERU5QyNNAal+cgNDVohybwRNJA=";

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

  doInstallCheck = false;

  meta = {
    description = "mini cli search engine for your docs, knowledge bases, meeting notes, whatever.";
    homepage = "https://github.com/tobi/qmd";
    changelog = "https://github.com/tobi/qmd/releases/tag/v2.8.3";
    license = lib.licenses.mit;
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryNativeCode
    ];
    platforms = lib.platforms.unix;
    mainProgram = "qmd";
  };
}
