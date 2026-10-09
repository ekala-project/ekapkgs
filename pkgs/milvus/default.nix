{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  glibc,
}:

# Milvus does not ship standalone server binaries, and building the full
# distributed server from source requires conan to download its C++ core
# dependencies at build time (sandbox-hostile; nixpkgs leaves it unpackaged).
# The official `milvus-lite` wheel, however, bundles the real Milvus server
# binary and its knowhere vector engine. We package that server directly.
stdenv.mkDerivation (finalAttrs: {
  pname = "milvus";
  version = "2.5.1";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/d3/82/41d9b80f09b82e066894d9b508af07b7b0fa325ce0322980674de49106a0/milvus_lite-2.5.1-py3-none-manylinux2014_x86_64.whl";
    hash = "sha256-Jc4T9LjUaHbdK3rIVj19gwbaf/OZm7DRSxFrMPcdcGw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  unpackPhase = ''
    runHook preUnpack
    mkdir -p source
    cd source
    unzip -q "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/milvus $out/bin
    cp milvus_lite/lib/milvus $out/lib/milvus/
    cp milvus_lite/lib/*.so* $out/lib/milvus/

    makeWrapper $out/lib/milvus/milvus $out/bin/milvus \
      --prefix LD_LIBRARY_PATH : "$out/lib/milvus"
    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [ "libz.so.1" ];

  meta = {
    description = "Lightweight embedded/distributed vector database (server binary from the official milvus-lite wheel)";
    longDescription = ''
      The `milvus` server binary and its knowhere vector engine, extracted from
      the official milvus-lite wheel. This is the single-node/embedded Milvus.
    '';
    homepage = "https://milvus.io";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "milvus";
  };
})
