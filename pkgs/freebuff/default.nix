{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.2.6";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "freebuff: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-jfzwaw/7k46JkufD7JpSKmhHNK4UUdXckd3kiHRZPBM=";
    aarch64-linux = "sha256-tQ3dXWHLU8uUOtRE6my0INGR5D0YTdtqanr/4YKbFtU=";
    aarch64-darwin = "sha256-BUg9HzWkzw55KbDaEwoEPxQytPHhffJ9WyTuGHMrBP0=";
  };
in
stdenv.mkDerivation {
  pname = "freebuff";
  inherit version;

  src = fetchurl {
    url = "https://github.com/CodebuffAI/codebuff-community/releases/download/freebuff-v${version}/freebuff-${platform}.tar.gz";
    hash = hashes.${system};
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  sourceRoot = ".";

  # bun-compiled binary: stripping corrupts the embedded bytecode.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 freebuff $out/bin/freebuff
    install -m644 tree-sitter.wasm $out/bin/tree-sitter.wasm

    # TODO(corepkgs): add ripgrep to the runtime PATH
    wrapProgram $out/bin/freebuff --argv0 freebuff

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Free coding agent from Codebuff";
    homepage = "https://freebuff.com";
    changelog = "https://github.com/CodebuffAI/codebuff-community/releases";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "freebuff";
  };
}
