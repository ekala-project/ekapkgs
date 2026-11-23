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
  version = "2.4.1";

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
    x86_64-linux = "sha256-nd0Y4/r2Tq7M9qD8vJalx6FFIK5f1bYeW+UdiU9Hi0c=";
    aarch64-linux = "sha256-yyjPlFQa62KksupZl6mbXda65ZWncvNvvieSmfIDKk8=";
    aarch64-darwin = "sha256-laEB7alRCEePHbQ8/4/L1IEfbA55rx4WcwGEPGpI1zE=";
  };
in
stdenv.mkDerivation {
  pname = "opencode";
  inherit version;

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/${platformInfo.asset}";
    hash = hashes.${platform};
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals platformInfo.isZip [ unzip ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontConfigure = true;

  dontBuild = true;

  # otherwise strip removes the compressed typescript code
  dontStrip = true;

  unpackPhase =
    ""
    + lib.optionalString platformInfo.isZip ''
      unzip $src
    ''
    + lib.optionalString (!platformInfo.isZip) ''
      tar -xzf $src
    ''
    + "";

  installPhase = ''
    mkdir -p $out/bin
    install -m755 opencode $out/bin/opencode
    wrapProgram $out/bin/opencode \
      --prefix PATH : ${
        lib.makeBinPath [
          fzf
          ripgrep
        ]
      }
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
