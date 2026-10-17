{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "1.105.1";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/sass/dart-sass/releases/download/${version}/dart-sass-${version}-linux-x64.tar.gz";
      hash = "sha256-kEb91KMaUkoAICmMVdnhVdTCI2PvJo6JkldDNacsam8=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/sass/dart-sass/releases/download/${version}/dart-sass-${version}-linux-arm64.tar.gz";
      hash = "sha256-f1Oip370qvJKny+MgmdZ7ZOziVRDCi4yEwkhouFqShw=";
    };
  };
in
stdenv.mkDerivation {
  pname = "dart-sass";
  inherit version;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "dart-sass: unsupported system ${stdenv.hostPlatform.system}");

  sourceRoot = "dart-sass";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/dart-sass

    # The tarball has: src/dart (Dart VM), src/sass.snapshot, sass (wrapper)
    install -Dm755 src/dart $out/share/dart-sass/dart
    install -Dm644 src/sass.snapshot $out/share/dart-sass/sass.snapshot

    cat > $out/bin/sass <<WRAPPER
    #!/bin/sh
    exec "$out/share/dart-sass/dart" "$out/share/dart-sass/sass.snapshot" "\$@"
    WRAPPER
    chmod +x $out/bin/sass

    ln -s $out/bin/sass $out/bin/dart-sass

    runHook postInstall
  '';

  meta = {
    description = "Reference implementation of Sass, written in Dart";
    homepage = "https://github.com/sass/dart-sass";
    license = lib.licenses.mit;
    mainProgram = "sass";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames sources;
  };
}
