{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  zlib,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  hashes = builtins.fromJSON (builtins.readFile ./hashes.json);
  inherit (hashes) version;

  urlMap = {
    x86_64-linux = "eca-native-linux-amd64.zip";
    aarch64-linux = "eca-native-linux-aarch64.zip";
    aarch64-darwin = "eca-native-macos-aarch64.zip";
  };

  file = urlMap.${stdenv.hostPlatform.system}
    or (throw "Unsupported system for eca: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "eca";
  inherit version;

  src = fetchurl {
    url = "https://github.com/editor-code-assistant/eca/releases/download/${version}/${file}";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  nativeBuildInputs = [ unzip ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ zlib ];

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  dontBuild = true;
  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp eca $out/bin/eca
    chmod +x $out/bin/eca
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Editor Code Assistant (ECA) - AI pair programming capabilities agnostic of editor";
    homepage = "https://github.com/editor-code-assistant/eca";
    changelog = "https://github.com/editor-code-assistant/eca/releases/tag/${version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "eca";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
