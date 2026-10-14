{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  unzip,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.8.2";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "coderabbit-cli: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-pjREhRU8WInJG65x2RcsDS19OSSkVmEXMDDihXC7e7I=";
    aarch64-linux = "sha256-OwhxfUDVH9LYhKTvDZfz4BcmzKcWNlOzhAUxOtOY3I8=";
    aarch64-darwin = "sha256-YJHQMWS0cZC027IN6XMS95veA/w1tLfCcF+PTTuoBn4=";
  };
in
stdenv.mkDerivation {
  pname = "coderabbit-cli";
  inherit version;

  src = fetchurl {
    url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-${platform}.zip";
    hash = hashes.${system};
  };

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  # TODO(corepkgs): add libsecret for credential storage

  unpackPhase = ''
    unzip $src
  '';

  # bun-compiled binary: stripping corrupts the embedded bytecode.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 coderabbit $out/bin/coderabbit
    ln -s $out/bin/coderabbit $out/bin/cr
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "AI-powered code review CLI";
    homepage = "https://coderabbit.ai";
    changelog = "https://docs.coderabbit.ai/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "coderabbit";
  };
}
