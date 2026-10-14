{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
}:

let
  version = "0.15.5-74c4cf2";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "ori: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-6o63fkkHLR6fzGz7ZT2L7DOf+ZJTsxZPnU/8x6+So7g=";
    aarch64-linux = "sha256-d0VbcDs6hjuzqKX6UOxFrLSuixmr/7y3pVAej9cmnto=";
    aarch64-darwin = "sha256-RI40am2CUZSB8HEFdvmC53QpO7VG4y6i/51ZVs+mSFE=";
  };
in
stdenv.mkDerivation {
  pname = "ori";
  inherit version;

  src = fetchurl {
    url = "https://github.com/OpenRouterLabs/ori-releases/releases/download/cli-${version}/ori-${platform}";
    hash = hashes.${system};
  };

  dontUnpack = true;
  # bun-compiled binary: stripping corrupts the embedded bytecode.
  dontStrip = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/ori
    wrapProgram $out/bin/ori --set-default ORI_TELEMETRY 0
    runHook postInstall
  '';

  # ori prints the build hash with '+' (0.15.5+74c4cf2) while the release tag
  # spells it with '-', so the stock versionCheckHook grep can never match.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME=$(mktemp -d) $out/bin/ori --version | grep -F "${lib.replaceStrings [ "-" ] [ "+" ] version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "OpenRouter CLI for managing agent environments across coding tools";
    homepage = "https://openrouter.ai/labs/ori";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "ori";
  };
}
