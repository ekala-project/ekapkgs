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
  hashes = {
    version = "0.161.2";
    x86_64-linux = "sha256-iDpadJcB3p+NB+ujk8puZtJU+QtSz8guIu0jFtcLQRY=";
    aarch64-linux = "sha256-hmVq2UnuZH+sm4Dr9V6puAiEctHtMR0zZ9fbsRlLy/E=";
    aarch64-darwin = "sha256-forsfElk1WoHcssgFbIkeadL477FhE6U6p/BGMGIH/Q=";
    jar = "sha256-xclS+1q8xmk+/AzHXi1MIxWqn6pgxN3/cgDZ8thnlvA=";
  };
  inherit (hashes) version;

  urlMap = {
    x86_64-linux = "eca-native-linux-amd64.zip";
    aarch64-linux = "eca-native-linux-aarch64.zip";
    aarch64-darwin = "eca-native-macos-aarch64.zip";
  };

  file =
    urlMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system for eca: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "eca";
  inherit version;

  src = fetchurl {
    url = "https://github.com/editor-code-assistant/eca/releases/download/${version}/${file}";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
