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
    version = "0.173.1";
    x86_64-linux = "sha256-Mdjks9/xr+tDW0BRriXIu31UeRLhZw4ZeIVRkSApEcg=";
    aarch64-linux = "sha256-oshpJOm7zn6eBTQUKSUuILJ/DohX3Zr91dJcXDSW0Oc=";
    aarch64-darwin = "sha256-4YYroqhjlWBmk5ztubuG/vtVYS/TzqERimOUGAxed0w=";
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
    unzip $src
  '';

  dontBuild = true;

  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    mkdir -p $out/bin
    cp eca $out/bin/eca
    chmod +x $out/bin/eca
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
