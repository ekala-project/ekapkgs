{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "1.6.10";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "executor: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-hdRGpka6/MUlpyEnoJhwoI96Y4P9f8Gge1+yHw/JYzU=";
    aarch64-linux = "sha256-ZAAjiytRG0hdq87pbzsgQrHok6IPZVyoJyOqAX4cdpM=";
    aarch64-darwin = "sha256-QjVJum4VIcK7O51JtzIibzJ8C5vXiZN0u6fr+Uy2gHY=";
  };
in
stdenv.mkDerivation {
  pname = "executor";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/executor/-/executor-${version}-${platform}.tgz";
    hash = hashes.${system};
  };

  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontBuild = true;
  # bun --compile binary: its payload trailer must stay at EOF.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/executor
    cp -r . $out/lib/executor

    makeWrapper $out/lib/executor/bin/executor $out/bin/executor \
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
      ''}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Secure self-hosted tool execution platform for AI agents";
    homepage = "https://github.com/UsefulSoftwareCo/executor";
    license = lib.licenses.mit;
    mainProgram = "executor";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
