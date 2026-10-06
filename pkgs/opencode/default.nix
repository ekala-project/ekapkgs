{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  fzf,
  ripgrep,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeShellScriptBin,
}:

let
  version = "1.18.34";

  platformMap = {
    x86_64-linux = {
      asset = "opencode-linux-x64.tar.gz";
      isZip = false;
    };
    aarch64-linux = {
      asset = "opencode-linux-arm64.tar.gz";
      isZip = false;
    };
    aarch64-darwin = {
      asset = "opencode-darwin-arm64.zip";
      isZip = true;
    };
  };

  platform = stdenv.hostPlatform.system;
  platformInfo = platformMap.${platform} or (throw "opencode: unsupported system ${platform}");

  hashes = {
    x86_64-linux = "sha256-DyJHlkcibR0t2ZWV0gCC7nvaOHC2LcapC0Hvwacdfpo=";
    aarch64-linux = "sha256-u9s/AMLFHkLjFVJSMxUTCXJCJqh3bajpFF47D6PVMQ8=";
    aarch64-darwin = "sha256-hSK3D1RRhLOo2XxcpPgUCTskdtcq6/2oxIvNBy7DHRs=";
  };
in
stdenv.mkDerivation {
  pname = "opencode";
  inherit version;

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/${platformInfo.asset}";
    hash = hashes.${platform};
  };

  nativeBuildInputs =
    [ makeWrapper ]
    ++ lib.optionals platformInfo.isZip [ unzip ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontConfigure = true;
  dontBuild = true;
  # otherwise strip removes the compressed typescript code
  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
  ''
  + lib.optionalString platformInfo.isZip ''
    unzip $src
  ''
  + lib.optionalString (!platformInfo.isZip) ''
    tar -xzf $src
  ''
  + ''
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 opencode $out/bin/opencode
    wrapProgram $out/bin/opencode \
      --prefix PATH : ${lib.makeBinPath [ fzf ripgrep ]}
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (writeShellScriptBin "sysctl" "echo 0")
  ];
  versionCheckKeepEnvironment = "PATH";

  meta = {
    description = "AI coding agent built for the terminal";
    homepage = "https://github.com/anomalyco/opencode";
    changelog = "https://github.com/anomalyco/opencode/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "opencode";
  };
}
