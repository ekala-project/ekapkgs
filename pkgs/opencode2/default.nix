{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wayland,
  ripgrep,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "2.0.21";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "opencode2: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-V9tCGraJ1oMReMhHNroeZnycJ2J4ZoSaEU+levvIF4U=";
    aarch64-linux = "sha256-BGwODo7sj2CF1GwOyins5l+wDiHfCIHIHLz3OSRYsdI=";
    aarch64-darwin = "sha256-UfLVPv0Q0SfZyXzj99FcWEvbJbe2mnnQsvQwfXphQPg=";
  };
in
stdenv.mkDerivation {
  pname = "opencode2";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@opencode/cli-${platform}/-/cli-${platform}-${version}.tgz";
    hash = hashes.${system};
  };

  sourceRoot = "package";

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    wayland
  ];

  dontBuild = true;
  # Bun-compiled executable; stripping corrupts the embedded payload.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/opencode $out/bin/opencode2
    wrapProgram $out/bin/opencode2 \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "OpenCode 2 CLI";
    longDescription = ''
      OpenCode 2 is OpenCode's next-generation CLI. The single executable
      includes the terminal interface and server, and can run with a private
      server, reuse a background service, or connect to a remote server.
    '';
    homepage = "https://opencode.ai";
    changelog = "https://github.com/anomalyco/opencode/commits/v2";
    downloadPage = "https://www.npmjs.com/package/@opencode/cli?activeTab=versions";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "opencode2";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
