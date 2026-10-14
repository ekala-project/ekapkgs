{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "20260930.234450.0-sha.657fe527";

  platformMap = {
    x86_64-linux = {
      os = "linux";
      cpu = "x86_64";
    };
    aarch64-linux = {
      os = "linux";
      cpu = "aarch64";
    };
    aarch64-darwin = {
      os = "darwin";
      cpu = "aarch64";
    };
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "swamp: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-t4vyNgKM6JCTxvvge2ZwmcTWIMWOfdHYOg3k+BQE3u8=";
    aarch64-linux = "sha256-c+3+/HnaUYUeCvjyWkyHKU65lN2SlZsK1H+HFO5JQIg=";
    aarch64-darwin = "sha256-/AEX3o8frJkgJwGcWYZ0IcTW0+DWgzF0vnzcMAP7JVU=";
  };

  inherit (platform) os cpu;
in
stdenv.mkDerivation {
  pname = "swamp";
  inherit version;

  src = fetchurl {
    url = "https://artifacts.swamp-club.com/swamp/${version}/binary/${os}/${cpu}/swamp-${version}-binary-${os}-${cpu}.tar.gz";
    hash = hashes.${system};
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontStrip = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 swamp $out/bin/swamp
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Deterministic automation for AI agents";
    homepage = "https://swamp-club.com/";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "swamp";
  };
}
