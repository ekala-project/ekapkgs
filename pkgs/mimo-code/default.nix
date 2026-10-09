{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  makeWrapper,
  fzf,
  ripgrep,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.1.15";

  platformMap = {
    x86_64-linux = {
      asset = "mimocode-linux-x64.tar.gz";
      isZip = false;
    };
    aarch64-linux = {
      asset = "mimocode-linux-arm64.tar.gz";
      isZip = false;
    };
    aarch64-darwin = {
      asset = "mimocode-darwin-arm64.zip";
      isZip = true;
    };
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "mimo-code: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-NTCSei1p6w+AnBH2Y+zWk5uCwLWY/w++H4L0Mddkygw=";
    aarch64-linux = "sha256-dJ6ocEzpjTAOHRYvr5gu0KN5X6tIvZhMHlyA8ucrAQE=";
    aarch64-darwin = "sha256-mAVobY4Upb/wkYM+wCGroOf31BNhzr+QFSSC5cOOQLM=";
  };
in
stdenv.mkDerivation {
  pname = "mimo-code";
  inherit version;

  src = fetchurl {
    url = "https://github.com/XiaomiMiMo/MiMo-Code/releases/download/v${version}/${platform.asset}";
    hash = hashes.${system};
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals platform.isZip [ unzip ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
  ''
  + lib.optionalString platform.isZip ''
    unzip $src
  ''
  + lib.optionalString (!platform.isZip) ''
    tar -xzf $src
  ''
  + ''
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 mimo $out/bin/mimo
    wrapProgram $out/bin/mimo \
      --prefix PATH : ${
        lib.makeBinPath [
          fzf
          ripgrep
        ]
      }
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Open-source AI coding agent with cross-session memory";
    homepage = "https://github.com/XiaomiMiMo/MiMo-Code";
    changelog = "https://github.com/XiaomiMiMo/MiMo-Code/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "mimo";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
