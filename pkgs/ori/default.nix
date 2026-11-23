{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
}:

let
  version = "0.17.4-6158ff7";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "ori: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-9jtoo7/wPvjM6Wmo7JKaWc4/82FPqqoSy2Q5qWCvhA0=";
    aarch64-linux = "sha256-nP2kpCN2BRaNevwEzrQ6B0NIgF5azhVshFvM/KijWgI=";
    aarch64-darwin = "sha256-o7tG4MYtw7lrE/9mBdj+UHqkb0LGh5O0b+CbxkA5n2E=";
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
    install -Dm755 $src $out/bin/ori
    wrapProgram $out/bin/ori --set-default ORI_TELEMETRY 0
  '';

  # ori prints the build hash with '+' (0.15.5+74c4cf2) while the release tag
  # spells it with '-', so the stock versionCheckHook grep can never match.
  doInstallCheck = true;

  installCheckPhase = ''
    HOME=$(mktemp -d) $out/bin/ori --version | grep -F "${lib.replaceStrings [ "-" ] [ "+" ] version}"
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
