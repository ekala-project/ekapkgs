{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  curl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mongodb-ce";
  version = "8.2.3";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform for mongodb-ce: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  dontStrip = true;

  buildInputs = [
    curl.dev
    openssl.dev
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 bin/mongod -t $out/bin
    install -Dm 755 bin/mongos -t $out/bin

    runHook postInstall
  '';

  passthru.sources = {
    "x86_64-linux" = fetchurl {
      url = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2404-${finalAttrs.version}.tgz";
      hash = "sha256-NjPVLSqm5CPaG9/yOL7wEWW2rwFYcgCqwIZNk/ObYI8=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2404-${finalAttrs.version}.tgz";
      hash = "sha256-oVgHrXLjbc7XBrBr8QtChGfyfs+hCot4Dt9I/Qf9X3E=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-${finalAttrs.version}.tgz";
      hash = "sha256-2jjP+vPAct+dcAn6RQLKrDyAsKQxj4kL+3XlDXfT1cQ=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://fastdl.mongodb.org/osx/mongodb-macos-arm64-${finalAttrs.version}.tgz";
      hash = "sha256-qUVQIeot2NO0ddrEW5jElu6HVyqiwTbR1S6KM2LJwV8=";
    };
  };

  meta = {
    changelog = "https://www.mongodb.com/docs/upcoming/release-notes/8.2/";
    description = "MongoDB is a general purpose, document-based, distributed database";
    homepage = "https://www.mongodb.com/";
    license = with lib.licenses; [ sspl ];
    longDescription = ''
      MongoDB CE (Community Edition) is a general purpose, document-based, distributed database.
      It is designed to be flexible and easy to use, with the ability to store data of any structure.
      This pre-compiled binary distribution package provides the MongoDB daemon (mongod) and the MongoDB Shard utility
      (mongos).
    '';
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "mongod";
  };
})
