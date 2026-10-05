{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
}:

let
  version = "1.4.2-R4684.1";

  platformMap = {
    x86_64-linux = "x86-linux";
    aarch64-linux = "aarch64-linux";
    aarch64-darwin = "aarch64-macos";
  };

  system = stdenvNoCC.hostPlatform.system;
  platform = platformMap.${system} or (throw "muse-code: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-37MJbJH0dnxNmABkYIALe6kGoLGkCCgKkmqNwZoa9k8=";
    aarch64-linux = "sha256-+ml0wjMHoNXbkTZ1SeQVBaXntV3NZsZy6y3YnBoSWtY=";
    aarch64-darwin = "sha256-6Zh+9CZ6ZI3BkxwoNqI/bxb4tEFzaLEmqBC+ziq9MI0=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "muse-code";
  inherit version;

  src = fetchurl {
    url = "https://lookaside.facebook.com/lookaside/muse/download/?channel=muse&version=${version}&file=muse-${platform}";
    hash = hashes.${system};
  };

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/muse
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Meta's terminal coding agent";
    homepage = "https://dev.meta.ai/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "muse";
  };
}
