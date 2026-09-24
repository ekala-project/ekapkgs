# dart — Dart SDK (pre-built binary)
{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  unzip,
}:

let
  version = "3.13.4";

  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x64";

  sources = {
    x86_64-linux = {
      hash = "sha256-ZIehDfXquJDXRtFKVfTHC+w8HAYz9RgE61BMvA/Dlbs=";
    };
    aarch64-linux = {
      hash = "sha256-HVRWCb352m+15o+9lqWZ4oNuRO5kN5mRvUST7nZNL9s=";
    };
  };
in
stdenv.mkDerivation {
  pname = "dart";
  inherit version;

  src = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-${arch}-release.zip";
    inherit
      (sources.${stdenv.hostPlatform.system}
        or (throw "dart: unsupported platform ${stdenv.hostPlatform.system}")
      )
      hash
      ;
  };

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r bin lib $out/
    runHook postInstall
  '';

  meta = {
    description = "Dart SDK";
    homepage = "https://dart.dev/";
    license = lib.licenses.bsd3;
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "dart";
  };
}
