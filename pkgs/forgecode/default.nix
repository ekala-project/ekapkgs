{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  versionCheckHook,
}:

let
  version = "2.13.21";

  platformMap = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    aarch64-darwin = "aarch64-apple-darwin";
  };
  platform = platformMap.${stdenv.hostPlatform.system}
    or (throw "Unsupported system for forgecode: ${stdenv.hostPlatform.system}");

  hashes = {
    x86_64-linux = "sha256-MArPaeOepaRS5lRPMZFHAxehQia2sakYIclYFeB6i4g=";
    aarch64-linux = "sha256-uTNrZSwSM6B96o606GR4XgPB2XBgJXaKGaw7ZkaTZTk=";
    aarch64-darwin = "sha256-+repgOS4EuOy5rSOLHrUfqXCGMqjZDCAgJCk3MdPAwI=";
  };
in
stdenv.mkDerivation {
  pname = "forgecode";
  inherit version;

  src = fetchurl {
    url = "https://github.com/tailcallhq/forgecode/releases/download/v${version}/forge-${platform}";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [ makeWrapper ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/forge
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/forge \
      --set-default FORGE_UPDATES__FREQUENCY never \
      --set-default FORGE_UPDATES__AUTO_UPDATE false
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Forge - AI coding agent by Tailcall";
    homepage = "https://forgecode.dev";
    changelog = "https://github.com/tailcallhq/forgecode/releases/tag/v${version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "forge";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
